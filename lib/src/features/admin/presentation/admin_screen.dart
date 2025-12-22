import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/admin_orders_provider.dart';
import '../../cart/domain/reservation.dart';
import '../../../common/widgets/outlook_header.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialize to today, or nearest weekday if today is weekend
    final now = DateTime.now();
    if (now.weekday == DateTime.saturday) {
      // Saturday -> go to Friday
      _selectedDate = now.subtract(const Duration(days: 1));
    } else if (now.weekday == DateTime.sunday) {
      // Sunday -> go to Monday
      _selectedDate = now.add(const Duration(days: 1));
    } else {
      _selectedDate = now;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(adminOrdersProvider);

    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Column(
        children: [
          OutlookHeader(
            title: 'Catering',
            icon: CupertinoIcons.chart_bar_square,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                ref.read(adminOrdersProvider.notifier).refresh();
              },
              child: const Icon(CupertinoIcons.refresh, color: Colors.white, size: 24),
            ),
            bottomWidget: _buildDateNavigator(),
          ),
          Expanded(
            child: ordersAsync.when(
              data: (allOrders) {
                // Filter orders for selected date
                final selectedDateOnly = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
                final dayOrders = allOrders.where((order) {
                  final orderDate = DateTime(order.date.year, order.date.month, order.date.day);
                  return orderDate == selectedDateOnly;
                }).toList();

                if (dayOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.doc_text, size: 64, color: CupertinoColors.systemGrey3),
                        const SizedBox(height: 16),
                        Text(
                          _isToday() ? 'No orders for today' : 'No orders for this date',
                          style: const TextStyle(color: CupertinoColors.systemGrey),
                        ),
                      ],
                    ),
                  );
                }

                // Group orders by food name
                final Map<String, List<Reservation>> groupedByFood = {};
                for (var order in dayOrders) {
                  groupedByFood.putIfAbsent(order.foodName, () => []).add(order);
                }

                // Calculate totals
                final totalOrders = dayOrders.length;
                final completedOrders = dayOrders.where((order) => order.delivered).length;

                return Column(
                  children: [
                    // Summary Statistics
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C6B6B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Orders', totalOrders.toString(), CupertinoIcons.doc_text),
                          Container(width: 1, height: 40, color: CupertinoColors.separator),
                          _buildStatItem('Completed', completedOrders.toString(), CupertinoIcons.checkmark_circle),
                        ],
                      ),
                    ),

                    // Food Groups List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 40),
                        itemCount: groupedByFood.length,
                        itemBuilder: (context, index) {
                          final foodName = groupedByFood.keys.elementAt(index);
                          final foodOrders = groupedByFood[foodName]!;
                          final totalQuantity = foodOrders.fold(0, (sum, order) => sum + order.quantity);
                          
                          return _buildFoodGroupCard(foodName, foodOrders, totalQuantity);
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.exclamationmark_triangle, size: 64, color: CupertinoColors.systemRed),
                    const SizedBox(height: 16),
                    Text('Error: $err', style: const TextStyle(color: CupertinoColors.systemRed)),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      child: const Text('Retry'),
                      onPressed: () => ref.read(adminOrdersProvider.notifier).refresh(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodGroupCard(String foodName, List<Reservation> orders, int totalQuantity) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF2C6B6B),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    foodName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB4FF39),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalQuantity meals',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C6B6B),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Individual Orders
          ...orders.asMap().entries.map((entry) {
            final index = entry.key;
            final order = entry.value;
            final isLast = index == orders.length - 1;
            
            return Column(
              children: [
                _buildOrderRow(order),
                if (!isLast)
                  const Divider(height: 1, indent: 16, endIndent: 16),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderRow(Reservation order) {
    final isDelivered = order.delivered;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () async {
              // Update delivery status in database
              await ref.read(adminOrdersProvider.notifier).updateDeliveryStatus(order.id, !isDelivered);
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDelivered ? const Color(0xFF2C6B6B) : Colors.white,
                border: Border.all(
                  color: isDelivered ? const Color(0xFF2C6B6B) : CupertinoColors.systemGrey3,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isDelivered
                  ? const Icon(CupertinoIcons.check_mark, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // Quantity Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2C6B6B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${order.quantity}x',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C6B6B),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // User Name
          Expanded(
            child: Text(
              '${order.userName ?? ''} ${order.userSurname ?? ''}'.trim().isEmpty 
                  ? order.userId 
                  : '${order.userName ?? ''} ${order.userSurname ?? ''}'.trim(),
              style: TextStyle(
                fontSize: 15,
                color: isDelivered ? CupertinoColors.systemGrey : CupertinoColors.label,
                decoration: isDelivered ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Order Type Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: order.orderType == ReservationOrderType.pickup
                  ? CupertinoColors.systemOrange.withOpacity(0.1)
                  : const Color(0xFF2C6B6B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  order.orderType == ReservationOrderType.pickup
                      ? CupertinoIcons.bag
                      : CupertinoIcons.house,
                  size: 12,
                  color: order.orderType == ReservationOrderType.pickup
                      ? CupertinoColors.systemOrange
                      : const Color(0xFF2C6B6B),
                ),
                const SizedBox(width: 4),
                Text(
                  order.orderType == ReservationOrderType.pickup ? 'Pickup' : 'Rest.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: order.orderType == ReservationOrderType.pickup
                        ? CupertinoColors.systemOrange
                        : const Color(0xFF2C6B6B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateNavigator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Day Button
          CupertinoButton(
            padding: const EdgeInsets.all(8),
            onPressed: () {
              setState(() {
                _selectedDate = _getPreviousWeekday(_selectedDate);
              });
            },
            child: const Icon(CupertinoIcons.chevron_left, color: Colors.white, size: 24),
          ),

          // Date Display
          Expanded(
            child: GestureDetector(
              onTap: () => _showDatePicker(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFB4FF39),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.calendar, size: 18, color: Color(0xFF2C6B6B)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _formatSelectedDate(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C6B6B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Next Day Button
          CupertinoButton(
            padding: const EdgeInsets.all(8),
            onPressed: () {
              setState(() {
                _selectedDate = _getNextWeekday(_selectedDate);
              });
            },
            child: const Icon(CupertinoIcons.chevron_right, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: CupertinoColors.systemBackground,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                onDateTimeChanged: (DateTime newDate) {
                  // Only allow weekdays
                  if (newDate.weekday >= 1 && newDate.weekday <= 5) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2C6B6B)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C6B6B),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: CupertinoColors.secondaryLabel,
          ),
        ),
      ],
    );
  }

  String _formatSelectedDate() {
    if (_isToday()) {
      return 'Today';
    } else if (_isTomorrow()) {
      return 'Tomorrow';
    } else if (_isYesterday()) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE, d MMMM').format(_selectedDate);
    }
  }

  bool _isToday() {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  bool _isTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return _selectedDate.year == tomorrow.year &&
        _selectedDate.month == tomorrow.month &&
        _selectedDate.day == tomorrow.day;
  }

  bool _isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _selectedDate.year == yesterday.year &&
        _selectedDate.month == yesterday.month &&
        _selectedDate.day == yesterday.day;
  }

  DateTime _getPreviousWeekday(DateTime date) {
    DateTime previous = date.subtract(const Duration(days: 1));
    // If previous day is Saturday (6), go to Friday
    if (previous.weekday == DateTime.saturday) {
      previous = previous.subtract(const Duration(days: 1));
    }
    // If previous day is Sunday (7), go to Friday
    else if (previous.weekday == DateTime.sunday) {
      previous = previous.subtract(const Duration(days: 2));
    }
    return previous;
  }

  DateTime _getNextWeekday(DateTime date) {
    DateTime next = date.add(const Duration(days: 1));
    // If next day is Saturday (6), go to Monday
    if (next.weekday == DateTime.saturday) {
      next = next.add(const Duration(days: 2));
    }
    // If next day is Sunday (7), go to Monday
    else if (next.weekday == DateTime.sunday) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }
}
