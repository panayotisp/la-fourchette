import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/outlook_header.dart';
import '../../cart/data/reservation_repository.dart';
import '../../cart/domain/reservation.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(reservationRepositoryProvider);


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
              data: (reservations) {
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

                // Group items by name for display (Cart Logic)
                // Map<itemId, List<Reservation>>
                final groupedItems = <String, List<Reservation>>{};
                for (var r in reservations) {
                  if (r.status == ReservationStatus.confirmed) {
                    groupedItems.putIfAbsent(r.foodItemId, () => []).add(r);
                  }
                }
                
                final total = reservations.fold(0.0, (sum, item) => sum + (item.status == ReservationStatus.confirmed ? item.price : 0));

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: groupedItems.keys.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final itemId = groupedItems.keys.elementAt(index);
                          final items = groupedItems[itemId]!;
                          final firstItem = items.first;
                          final quantity = items.length;
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
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey6,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(CupertinoIcons.ticket, color: CupertinoColors.activeBlue),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(firstItem.foodName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text('${quantity}x €${firstItem.price.toStringAsFixed(2)}', style: const TextStyle(color: CupertinoColors.secondaryLabel)),
                                    ],
                                  ),
                                ),
                                Text('€${itemTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Total Footer
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 20 + MediaQuery.of(context).padding.bottom),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: CupertinoColors.separator)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('€${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue)),
                        ],
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
}
