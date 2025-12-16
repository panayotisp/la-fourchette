import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/food_item.dart';
import '../../cart/data/api_reservation_repository.dart';
import '../../cart/domain/reservation.dart';
import 'food_detail_sheet.dart';

class DailyMenuList extends StatelessWidget {
  final List<FoodItem> items;
  final DateTime date;

  const DailyMenuList({super.key, required this.items, required this.date});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No menu available for this day.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 100), // Safe area for bottom nav if any
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _FoodItemCard(item: item, date: date)
            .animate()
            .fadeIn(duration: 400.ms, delay: (50 * index).ms)
            .slideX(begin: 0.1, curve: Curves.easeOut);
      },
    );
  }
}


class _FoodItemCard extends ConsumerWidget {
  final FoodItem item;
  final DateTime date;

  const _FoodItemCard({required this.item, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if date is in the past
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final menuDate = DateTime(date.year, date.month, date.day);
    final isPast = menuDate.isBefore(today);

    // Watch cart to get quantity
    final cartAsync = ref.watch(apiReservationRepositoryProvider);
    final quantity = cartAsync.when(
      data: (reservations) => reservations.where((r) => r.foodItemId == item.id && r.status == ReservationStatus.confirmed).fold(0, (sum, r) => sum + r.quantity),
      loading: () => 0,
      error: (_, __) => 0,
    );
    final hasQuantity = quantity > 0;

    Widget cardContent = GestureDetector(
       onTap: isPast ? null : () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useRootNavigator: true, 
            backgroundColor: Colors.transparent,
            builder: (context) => FoodDetailSheet(item: item),
          );
        },
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              // padding: const EdgeInsets.all(12), // Adjusted padding handled inside Row
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Vertical Indicator (if selected)
                      if (hasQuantity)
                        Container(
                          width: 4,
                          color: CupertinoColors.activeBlue, // Simple rect, let ClipRRect handle corners
                        ),
                      
                      // 2. Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title & Price (Left Side)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title with optional quantity
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontFamily: 'SF Pro Display',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.5,
                                          color: isPast ? CupertinoColors.secondaryLabel : CupertinoColors.label,
                                        ),
                                        children: [
                                          if (hasQuantity)
                                            TextSpan(
                                              text: '$quantity x ',
                                              style: const TextStyle(color: CupertinoColors.activeBlue),
                                            ),
                                          TextSpan(text: item.name),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '€${item.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isPast ? CupertinoColors.systemGrey3 : CupertinoColors.activeBlue,
                                      ),
                                    ),
                                    if (isPast)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Unavailable',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: CupertinoColors.systemGrey2, 
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Image (Right Side)
                              Opacity(
                                opacity: isPast ? 0.5 : 1.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: item.imageUrl.startsWith('http') 
                                    ? Image.network(
                                        item.imageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => _buildPlaceholder(),
                                      )
                                    : Image.asset(
                                        item.imageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => _buildPlaceholder(),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

    if (isPast) {
      // Return just the card without swipe functionality
      return cardContent;
    }

    return Dismissible(
      key: Key(item.id),
      direction: hasQuantity ? DismissDirection.horizontal : DismissDirection.startToEnd,
      dismissThresholds: const {
        DismissDirection.startToEnd: 0.3,
        DismissDirection.endToStart: 0.3,
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe Right -> Add 1 (User requested: "Drag a card to the right... to Add")
          ref.read(apiReservationRepositoryProvider.notifier).addReservation(
            userId: 'current_user',
            foodItemId: item.id,
            foodName: item.name,
            date: DateTime.now(),
            price: item.price,
          );
          return false; // Don't dismiss
        } else if (direction == DismissDirection.endToStart) {
          // Swipe Left -> Remove All ("Drag a card to the left... to Remove")
          ref.read(apiReservationRepositoryProvider.notifier).removeReservation(foodItemId: item.id);
          return false; // Don't dismiss
        }
        return false;
      },
      // Background (Swipe Right -> StartToEnd) -> Add (Blue)
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: CupertinoColors.activeBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        child: const Icon(CupertinoIcons.cart_fill_badge_plus, color: Colors.white),
      ),
      // Secondary Background (Swipe Left -> EndToStart) -> Remove (Red)
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: CupertinoColors.destructiveRed,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(CupertinoIcons.trash, color: Colors.white),
      ),
      child: cardContent,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: CupertinoColors.systemGrey5,
      child: const Icon(CupertinoIcons.photo, color: CupertinoColors.systemGrey3),
    );
  }
}
