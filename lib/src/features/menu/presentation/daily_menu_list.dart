import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../domain/food_item.dart';
import '../../cart/data/reservation_repository.dart';

class DailyMenuList extends StatelessWidget {
  final List<FoodItem> items;

  const DailyMenuList({super.key, required this.items});

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
        return _FoodItemCard(item: item)
            .animate()
            .fadeIn(duration: 400.ms, delay: (50 * index).ms)
            .slideX(begin: 0.1, curve: Curves.easeOut);
      },
    );
  }
}

class _FoodItemCard extends ConsumerWidget {
  final FoodItem item;

  const _FoodItemCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder (Rounded Rect)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.imageUrl.startsWith('http') 
              ? Image.network(
                  item.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: CupertinoColors.systemGrey5,
                    child: const Icon(CupertinoIcons.photo, color: CupertinoColors.systemGrey3),
                  ),
                )
              : Image.asset(
                  item.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: CupertinoColors.systemGrey5,
                    child: const Icon(CupertinoIcons.photo, color: CupertinoColors.systemGrey3),
                  ),
                ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.secondaryLabel,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '€${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                    const Spacer(),
                    if (item.stock != null)
                      Text(
                        '${item.stock} left',
                        style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    const SizedBox(width: 8),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: () {
                         ref.read(reservationRepositoryProvider.notifier).addReservation(
                           userId: 'current_user', // Mock user
                           foodItemId: item.id,
                           foodName: item.name,
                           date: DateTime.now(),
                         );
                         showCupertinoDialog(
                           context: context,
                           builder: (context) => CupertinoAlertDialog(
                             title: const Text('Confirmed'),
                             content: Text('You reserved ${item.name}'),
                             actions: [
                               CupertinoDialogAction(
                                 child: const Text('OK'),
                                 onPressed: () => Navigator.pop(context),
                               )
                             ],
                           ),
                         );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Reserve',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
