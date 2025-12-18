import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/outlook_header.dart';
import '../data/api_reservation_repository.dart';
import '../../../common/services/notification_service.dart';
import '../../cart/domain/reservation.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(apiReservationRepositoryProvider);


    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Column(
        children: [
          const OutlookHeader(
            title: 'Cart',
            icon: CupertinoIcons.cart,
          ),
          Expanded(
            child: cartAsync.when(
              data: (allReservations) {
                // Filter only active cart items
                final reservations = allReservations.where((r) => r.status == ReservationStatus.cart).toList();

                if (reservations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.cart, size: 64, color: CupertinoColors.systemGrey),
                        const SizedBox(height: 16),
                        const Text('Your cart is empty', style: TextStyle(color: CupertinoColors.secondaryLabel)),
                      ],
                    ),
                  );
                }

                // Group items by date, then by foodItemId
                // Map<DateTime, Map<String, List<Reservation>>>
                final groupedByDate = <DateTime, Map<String, List<Reservation>>>{};
                
                for (var r in reservations) {
                    // Check if date or simplified date is needed. Assuming r.date is correct.
                    // Normalize date to remove time if needed (though API sends menu_date as date-only usually or we should parse it such)
                    final dateKey = DateTime(r.date.year, r.date.month, r.date.day);
                    
                    groupedByDate.putIfAbsent(dateKey, () => {});
                    groupedByDate[dateKey]!.putIfAbsent(r.foodItemId, () => []).add(r);
                }

                final sortedDates = groupedByDate.keys.toList()..sort();
                final total = reservations.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

                return Stack(
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.only(
                        top: 0, 
                        bottom: 160 + MediaQuery.of(context).padding.bottom, // Space for footer
                      ),
                      itemCount: sortedDates.length,
                      itemBuilder: (context, index) {
                        final date = sortedDates[index];
                        final groupedItems = groupedByDate[date]!;
                        
                        // Format Date Header
                        final dayName = _getDayName(date.weekday);
                        final monthName = _getMonthName(date.month);
                        final dateString = '$dayName ${date.day} $monthName';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Date Header
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                              child: Text(
                                dateString,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.label,
                                ),
                              ),
                            ),
                            // Items for this date
                            ...groupedItems.keys.map((itemId) {
                              final items = groupedItems[itemId]!;
                              final firstItem = items.first;
                              final quantity = items.fold(0, (sum, r) => sum + r.quantity);
                              final itemTotal = firstItem.price * quantity;

                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(firstItem.foodName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
                                          const SizedBox(height: 6),
                                          Text('${quantity}x €${firstItem.price.toStringAsFixed(2)}', style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 15)),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: firstItem.orderType == ReservationOrderType.pickup 
                                                  ? CupertinoColors.systemOrange.withOpacity(0.1) 
                                                  : const Color(0xFF2C6B6B).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              firstItem.orderType == ReservationOrderType.pickup ? 'Pickup' : 'Restaurant',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: firstItem.orderType == ReservationOrderType.pickup 
                                                    ? CupertinoColors.systemOrange
                                                    : const Color(0xFF2C6B6B),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text('€${itemTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                  ],
                                ),
                              );
                            }), 
                          ],
                        );
                      },
                    ),
                    
                    // Fl§ Footer
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 20 + MediaQuery.of(context).padding.bottom),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95), // Slight transparency for overlay feel
                          border: const Border(top: BorderSide(color: CupertinoColors.separator)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('€${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C6B6B))),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: CupertinoButton(
                                color: const Color(0xFF2C6B6B), // Dark Green
                                borderRadius: BorderRadius.circular(12),
                                onPressed: () {
                                  // Checkout Flow
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoActionSheet(
                                    title: const Text('Confirm Reservation'),
                                    message: Text(
                                      'Total amount: €${total.toStringAsFixed(2)}\n\nPayment will be collected at the restaurant.\nYou can pay by cash or card.',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    actions: <CupertinoActionSheetAction>[
                                      CupertinoActionSheetAction(
                                        isDefaultAction: true,
                                        onPressed: () async {
                                          Navigator.pop(context); // Close sheet
                                          
                                          // Perform Checkout
                                          try {
                                             await ref.read(apiReservationRepositoryProvider.notifier).checkout('current_user');
                                             
                                             // Success!
                                             if (context.mounted) {
                                               // 1. Show Local Notification
                                               ref.read(notificationServiceProvider).showOrderConfirmedNotification();

                                               // 2. Show Success Dialog
                                               showCupertinoDialog(
                                                 context: context,
                                                 builder: (context) => CupertinoAlertDialog(
                                                   title: const Text('Success!'),
                                                   content: const Text('Your reservation has been placed. We look forward to seeing you!'),
                                                   actions: [
                                                     CupertinoDialogAction(
                                                       isDefaultAction: true,
                                                       onPressed: () => Navigator.pop(context),
                                                       child: const Text('OK'),
                                                     ),
                                                   ],
                                                 ),
                                               );
                                             }
                                          } catch (e) {
                                            if (context.mounted) {
                                               showCupertinoDialog(
                                                 context: context,
                                                 builder: (context) => CupertinoAlertDialog(
                                                   title: const Text('Error'),
                                                   content: Text(e.toString()),
                                                   actions: [
                                                     CupertinoDialogAction(
                                                       onPressed: () => Navigator.pop(context),
                                                       child: const Text('OK'),
                                                     ),
                                                   ],
                                                 ),
                                               );
                                            }
                                          }
                                        },
                                        child: const Text('Confirm Order'),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
