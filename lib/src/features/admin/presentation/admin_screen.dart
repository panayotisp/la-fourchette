import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/data/reservation_repository.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationsAsync = ref.watch(reservationRepositoryProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Catering Dashboard'),
      ),
      child: SafeArea(
        child: reservationsAsync.when(
          data: (reservations) {
            // Aggregate counts logic can be moved to a provider or Computed, but doing here for simplicity
            final counts = <String, int>{};
            for (var res in reservations) {
              counts[res.foodName] = (counts[res.foodName] ?? 0) + 1;
            }

            if (counts.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.doc_text, size: 64, color: CupertinoColors.systemGrey3),
                    SizedBox(height: 16),
                    Text('No orders yet', style: TextStyle(color: CupertinoColors.systemGrey)),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: counts.length,
              separatorBuilder: (_, __) => Container(height: 1, color: CupertinoColors.separator),
              itemBuilder: (context, index) {
                final foodName = counts.keys.elementAt(index);
                final count = counts[foodName]!;

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeBlue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.activeBlue,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          foodName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
