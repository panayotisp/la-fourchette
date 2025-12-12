import 'package:flutter/material.dart';
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
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
           // Image Header (Full Bleed)
           Stack(
             children: [
               // Image
               ClipRRect(
                 borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                 child: SizedBox(
                   height: 350,
                   width: double.infinity,
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
               
               // Drag Handle
               Positioned(
                 top: 10,
                 left: 0,
                 right: 0,
                 child: Center(
                   child: Container(
                     width: 40,
                     height: 5,
                     decoration: BoxDecoration(
                       color: Colors.white.withOpacity(0.8),
                       borderRadius: BorderRadius.circular(10),
                     ),
                   ),
                 ),
               ),

               // Close Button
               Positioned(
                 right: 16,
                 top: 16,
                 child: GestureDetector(
                   onTap: () => Navigator.pop(context),
                   child: Container(
                     padding: const EdgeInsets.all(8),
                     decoration: const BoxDecoration(
                       color: Colors.white,
                       shape: BoxShape.circle,
                     ),
                     child: const Icon(CupertinoIcons.xmark, size: 20, color: Colors.black),
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
                   Padding(
                     padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                     child: Text(
                       widget.item.name,
                       style: const TextStyle(
                         fontSize: 28,
                         fontWeight: FontWeight.bold,
                         letterSpacing: -0.5,
                         color: CupertinoColors.label,
                       ),
                     ),
                   ),
                   
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     child: Text(
                       '€${widget.item.price.toStringAsFixed(2)}',
                       style: const TextStyle(
                         fontSize: 24,
                         fontWeight: FontWeight.w600,
                         color: CupertinoColors.activeBlue, // Or red if matching the design
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
             child: Row(
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
                         child: const Text('-', style: TextStyle(fontSize: 24, color: CupertinoColors.activeBlue)),
                       ),
                       Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                       CupertinoButton(
                         padding: const EdgeInsets.symmetric(horizontal: 12),
                         onPressed: _increment,
                         child: const Text('+', style: TextStyle(fontSize: 24, color: CupertinoColors.activeBlue)),
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
                           price: widget.item.price,
                         );
                       }
                       Navigator.pop(context);
                     },
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         const Text(
                           'Add to order',
                           style: TextStyle(
                             fontWeight: FontWeight.w600,
                             color: Colors.white,
                           ),
                         ),
                         Text(
                           '€${(widget.item.price * _quantity).toStringAsFixed(2)}',
                           style: const TextStyle(
                             fontWeight: FontWeight.w600,
                             color: Colors.white,
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           ),
        ],
      ),
    );
  }
}
