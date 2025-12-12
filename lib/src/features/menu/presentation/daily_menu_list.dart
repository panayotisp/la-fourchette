import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../domain/food_item.dart';
import 'food_detail_sheet.dart';

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


class _FoodItemCard extends StatelessWidget {
  final FoodItem item;

  const _FoodItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true, // Fix: Show over bottom nav bar
          backgroundColor: Colors.transparent,
          builder: (context) => FoodDetailSheet(item: item),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground, // Fix contrast
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
                      color: CupertinoColors.label, // Safe for light/dark
                    ),
                  ),
                  // Description removed
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
