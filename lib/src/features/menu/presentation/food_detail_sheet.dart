import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/data/reservation_repository.dart';
import '../../menu/domain/food_item.dart';

class FoodDetailSheet extends ConsumerStatefulWidget {
  final FoodItem item;

  const FoodDetailSheet({super.key, required this.item});

  @override
  ConsumerState<FoodDetailSheet> createState() => _FoodDetailSheetState();
}

class _FoodDetailSheetState extends ConsumerState<FoodDetailSheet> {
  int _quantity = 1;

  void _increment() {
    setState(() => _quantity++);
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
           // Header with Drag Handle and Close Button
           Stack(
             children: [
               Container(
                 padding: const EdgeInsets.only(top: 10),
                 alignment: Alignment.center,
                 child: Container(
                   width: 40,
                   height: 5,
                   decoration: BoxDecoration(
                     color: CupertinoColors.systemGrey3,
                     borderRadius: BorderRadius.circular(10),
                   ),
                 ),
               ),
               Positioned(
                 right: 16,
                 top: 16,
                 child: GestureDetector(
                   onTap: () => Navigator.pop(context),
                   child: Container(
                     padding: const EdgeInsets.all(8),
                     decoration: const BoxDecoration(
                       color: CupertinoColors.systemGrey6,
                       shape: BoxShape.circle,
                     ),
                     child: const Icon(CupertinoIcons.xmark, size: 20, color: CupertinoColors.black),
                   ),
                 ),
               ),
             ],
           ),
           
           Expanded(
             child: SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   // Image
                   Container(
                     height: 300,
                     width: double.infinity,
                     margin: const EdgeInsets.all(16),
                     child: ClipRRect(
                       borderRadius: BorderRadius.circular(16),
                       child: widget.item.imageUrl.startsWith('http')
                           ? Image.network(
                               widget.item.imageUrl,
                               fit: BoxFit.cover,
                             )
                           : Image.asset(
                               widget.item.imageUrl,
                               fit: BoxFit.cover,
                             ),
                     ),
                   ),
                   
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 16),
                     child: Text(
                       widget.item.name,
                       style: const TextStyle(
                         fontSize: 28,
                         fontWeight: FontWeight.bold,
                         letterSpacing: -0.5,
                         // iOS contrast fix: use label color
                         color: CupertinoColors.label,
                       ),
                     ),
                   ),
                   
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     child: Row(
                       children: [
                         Text(
                           '€${widget.item.price.toStringAsFixed(2)}',
                           style: const TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.w600,
                             color: CupertinoColors.activeBlue,
                           ),
                         ),
                         const SizedBox(width: 10),
                         Text(
                           '€6.00', // Mock original price
                           style: const TextStyle(
                               fontSize: 16,
                               decoration: TextDecoration.lineThrough,
                               color: CupertinoColors.systemGrey,
                           ),
                         ),
                       ],
                     ),
                   ),

                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 16),
                     child: Text(
                       widget.item.description,
                       style: const TextStyle(
                         fontSize: 16,
                         color: CupertinoColors.secondaryLabel,
                         height: 1.4,
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ),

           // Bottom Action Bar
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
             decoration: const BoxDecoration(
               border: Border(top: BorderSide(color: CupertinoColors.separator)),
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Text('Add extra', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
                 const Text('Choose up to 8 items', style: TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 13)),
                 const SizedBox(height: 16),
                 Row(
                   children: [
                     // Quantity Selector
                     Container(
                       decoration: BoxDecoration(
                         color: CupertinoColors.systemGrey6,
                         borderRadius: BorderRadius.circular(12),
                       ),
                       child: Row(
                         children: [
                           CupertinoButton(
                             padding: const EdgeInsets.symmetric(horizontal: 12),
                             onPressed: _decrement,
                             child: const Text('-', style: TextStyle(fontSize: 20, color: CupertinoColors.activeBlue)),
                           ),
                           Text('$_quantity', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                           CupertinoButton(
                             padding: const EdgeInsets.symmetric(horizontal: 12),
                             onPressed: _increment,
                             child: const Text('+', style: TextStyle(fontSize: 20, color: CupertinoColors.activeBlue)),
                           ),
                         ],
                       ),
                     ),
                     const SizedBox(width: 16),
                     // Add to Order Button
                     Expanded(
                       child: CupertinoButton(
                         color: CupertinoColors.activeBlue,
                         borderRadius: BorderRadius.circular(12),
                         onPressed: () {
                           // Add N reservations
                           for (int i = 0; i < _quantity; i++) {
                             ref.read(reservationRepositoryProvider.notifier).addReservation(
                               userId: 'current_user',
                               foodItemId: widget.item.id,
                               foodName: widget.item.name,
                               date: DateTime.now(),
                             );
                           }
                           Navigator.pop(context);
                         },
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text('Add to order', style: TextStyle(fontWeight: FontWeight.w600)),
                             Text('€${(widget.item.price * _quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                           ],
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
