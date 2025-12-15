import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/data/api_reservation_repository.dart';
import '../../cart/domain/reservation.dart';
import '../../menu/domain/food_item.dart';

class FoodDetailSheet extends ConsumerStatefulWidget {
  final FoodItem item;

  const FoodDetailSheet({super.key, required this.item});

  @override
  ConsumerState<FoodDetailSheet> createState() => _FoodDetailSheetState();
}

class _FoodDetailSheetState extends ConsumerState<FoodDetailSheet> {
  int _quantity = 1;
  int _initialCartQuantity = 0;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final cartAsync = ref.watch(apiReservationRepositoryProvider);
      cartAsync.whenData((reservations) {
        final count = reservations.where((r) => r.foodItemId == widget.item.id && r.status == ReservationStatus.confirmed).fold(0, (sum, r) => sum + r.quantity);
        if (count > 0) {
          _initialCartQuantity = count;
          _quantity = count;
        }
      });
      _isInit = false;
    }
  }

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
    // Determine Button State
    // 1. New Item (not in cart) -> "Add to order" (Blue)
    // 2. In Cart, Quantity Unchanged -> "Remove" (Red)
    // 3. In Cart, Quantity Changed -> "Update order" (Blue)
    
    final bool isInCart = _initialCartQuantity > 0;
    final bool isQuantityChanged = _quantity != _initialCartQuantity;
    
    final bool isRemoveState = isInCart && !isQuantityChanged;
    final bool isUpdateState = isInCart && isQuantityChanged;
    
    // Logic for button
    final String buttonText = isRemoveState 
        ? 'Remove' 
        : (isUpdateState ? 'Update order' : 'Add to order');
        
    final Color buttonColor = isRemoveState 
        ? CupertinoColors.destructiveRed 
        : CupertinoColors.activeBlue;

    final double totalPrice = widget.item.price * _quantity;

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
                 // Quantity Selector (Only show if NOT in remove state, or always show? 
                 // User said "price next as it is", implies standard layout but button changes.
                 // However, "Remove" usually implies removing the item entirely, so quantity selector might be confusing if used to "set removal amount".
                 // BUT: The requirement says: "If a food already exists... instead of add... I want a red Remove". 
                 // It also says: "If a food exists... but user has changed amount... Update order".
                 // This implies standard quantity selector is always active.
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
                 // Action Button
                 Expanded(
                   child: CupertinoButton(
                     color: buttonColor,
                     borderRadius: BorderRadius.circular(12),
                     onPressed: () {
                       if (isRemoveState) {
                         // Remove Logic
                         ref.read(apiReservationRepositoryProvider.notifier).removeReservation(
                           foodItemId: widget.item.id,
                         );
                       } else if (isUpdateState) {
                         // Update Logic (Item exists)
                         ref.read(apiReservationRepositoryProvider.notifier).updateReservationQuantity(
                            userId: 'current_user',
                            foodItemId: widget.item.id,
                            foodName: widget.item.name,
                            date: DateTime.now(),
                            price: widget.item.price,
                            newQuantity: _quantity, 
                         );
                       } else {
                         // Add Logic (New Item)
                         ref.read(apiReservationRepositoryProvider.notifier).addReservation(
                            userId: 'current_user',
                            foodItemId: widget.item.id,
                            foodName: widget.item.name,
                            date: DateTime.now(),
                            price: widget.item.price,
                            quantity: _quantity,
                         );
                       }
                       Navigator.pop(context);
                     },
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(
                           buttonText,
                           style: const TextStyle(
                             fontWeight: FontWeight.w600,
                             color: Colors.white,
                           ),
                         ),
                         Text(
                           '€${totalPrice.toStringAsFixed(2)}',
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
