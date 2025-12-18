import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/outlook_header.dart';
import '../../cart/data/api_reservation_repository.dart';
import '../../cart/domain/reservation.dart';

class PurchaseHistoryScreen extends ConsumerWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(apiReservationRepositoryProvider);

    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Column(
        children: [
          OutlookHeader(
            title: 'History',
            icon: CupertinoIcons.time,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: cartAsync.when(
              data: (allReservations) {
                // 1. Filter for Confirmed items only
                final confirmedOrders = allReservations
                    .where((r) => r.status == ReservationStatus.confirmed)
                    .toList();

                // 2. Sort by Date Descending (Newest first)
                confirmedOrders.sort((a, b) => b.date.compareTo(a.date));

                if (confirmedOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.doc_text_search, size: 64, color: CupertinoColors.systemGrey),
                        const SizedBox(height: 16),
                        const Text('No purchase history yet', style: TextStyle(color: CupertinoColors.secondaryLabel)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(top: 20, bottom: 40),
                  itemCount: confirmedOrders.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = confirmedOrders[index];
                    return _OrderHistoryCard(order: order);
                  },
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

class _OrderHistoryCard extends StatelessWidget {
  final Reservation order;

  const _OrderHistoryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM d, yyyy');
    final total = order.price * order.quantity;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
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
          // Header: Date and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormatter.format(order.date),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label,
                  fontSize: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: CupertinoColors.activeGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Confirmed',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.activeGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Main Content: Name and Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.foodName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Type Badge (Pickup vs Restaurant)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: order.orderType == ReservationOrderType.pickup
                            ? CupertinoColors.systemOrange.withOpacity(0.1)
                            : CupertinoColors.activeBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order.orderType == ReservationOrderType.pickup ? 'Pickup' : 'Restaurant',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: order.orderType == ReservationOrderType.pickup
                              ? CupertinoColors.systemOrange
                              : CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '€${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.quantity}x €${order.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
