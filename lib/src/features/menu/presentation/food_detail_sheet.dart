import 'package:flutter/material.dart';
import '../../../common/theme/app_theme.dart';
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
  ReservationOrderType _selectedOrderType = ReservationOrderType.restaurant;
  ReservationOrderType _initialOrderType = ReservationOrderType.restaurant;
  
  // Split delivery quantities (used when _quantity >= 2)
  int _restaurantQuantity = 1;
  int _pickupQuantity = 0;
  bool _isSplitMode = false;
  
  // Initial state tracking (for change detection)
  bool _initialSplitMode = false;
  int _initialRestaurantQuantity = 0;
  int _initialPickupQuantity = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final cartAsync = ref.watch(apiReservationRepositoryProvider);
      cartAsync.whenData((reservations) {
        final existingItems = reservations.where((r) => r.foodItemId == widget.item.id && r.status == ReservationStatus.cart);
        final count = existingItems.fold(0, (sum, r) => sum + r.quantity);
        if (count > 0) {
          _initialCartQuantity = count;
          _quantity = count;
          
          // Check if there are multiple order types (split delivery)
          final orderTypes = existingItems.map((r) => r.orderType).toSet();
          final hasSplitOrders = orderTypes.length > 1;
          
          if (hasSplitOrders) {
            // Enable split mode and set quantities
            setState(() {
              _isSplitMode = true;
              _initialSplitMode = true;
              
              _restaurantQuantity = existingItems
                  .where((r) => r.orderType == ReservationOrderType.restaurant)
                  .fold(0, (sum, r) => sum + r.quantity);
              _initialRestaurantQuantity = _restaurantQuantity;
              
              _pickupQuantity = existingItems
                  .where((r) => r.orderType == ReservationOrderType.pickup)
                  .fold(0, (sum, r) => sum + r.quantity);
              _initialPickupQuantity = _pickupQuantity;
            });
          } else {
            // Single order type - set initial order type from existing reservation
            if (existingItems.isNotEmpty) {
              _selectedOrderType = existingItems.first.orderType;
              _initialOrderType = existingItems.first.orderType;
              _initialSplitMode = false;
            }
          }
        }
      });
      _isInit = false;
    }
  }

  void _increment() {
    setState(() {
      _quantity++;
      // Only auto-adjust split quantities if NOT in split mode
      if (!_isSplitMode && _quantity >= 2) {
        _restaurantQuantity = _quantity;
        _pickupQuantity = 0;
      }
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        // Only auto-adjust split quantities if NOT in split mode
        if (!_isSplitMode) {
          // Keep split quantities in sync with total
          if (_restaurantQuantity > _quantity) {
            _restaurantQuantity = _quantity;
          }
          if (_pickupQuantity > _quantity) {
            _pickupQuantity = 0;
          }
        }
      });
    }
  }
  
  void _incrementRestaurant() {
    if (_restaurantQuantity < _quantity) {
      setState(() {
        _restaurantQuantity++;
        // Auto-decrement pickup to maintain total
        if (_pickupQuantity > 0) {
          _pickupQuantity--;
        }
      });
    }
  }
  
  void _decrementRestaurant() {
    if (_restaurantQuantity > 0) {
      setState(() {
        _restaurantQuantity--;
        // Auto-increment pickup to maintain total
        if (_restaurantQuantity + _pickupQuantity < _quantity) {
          _pickupQuantity++;
        }
      });
    }
  }
  
  void _incrementPickup() {
    if (_pickupQuantity < _quantity) {
      setState(() {
        _pickupQuantity++;
        // Auto-decrement restaurant to maintain total
        if (_restaurantQuantity > 0) {
          _restaurantQuantity--;
        }
      });
    }
  }
  
  void _decrementPickup() {
    if (_pickupQuantity > 0) {
      setState(() {
        _pickupQuantity--;
        // Auto-increment restaurant to maintain total
        if (_restaurantQuantity + _pickupQuantity < _quantity) {
          _restaurantQuantity++;
        }
      });
    }
  }
  
  // Unified change detection
  bool _hasChanges() {
    // Quantity changed
    if (_quantity != _initialCartQuantity) return true;
    
    // Mode changed (split ↔ single)
    if (_isSplitMode != _initialSplitMode) return true;
    
    // In split mode: check split quantities
    if (_isSplitMode) {
      if (_restaurantQuantity != _initialRestaurantQuantity) return true;
      if (_pickupQuantity != _initialPickupQuantity) return true;
    }
    
    // In single mode: check order type
    if (!_isSplitMode && _selectedOrderType != _initialOrderType) return true;
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isInCart = _initialCartQuantity > 0;
    final bool hasChanges = _hasChanges();
    
    final String buttonText = isInCart && !hasChanges
        ? 'Remove' 
        : (isInCart && hasChanges ? 'Update order' : 'Add to order');
        
    final Color buttonColor = isInCart && !hasChanges
        ? CupertinoColors.destructiveRed 
        : AppTheme.darkGreen;

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
               child: SizedBox(
                 width: double.infinity, // Force full width for left alignment
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
                           color: AppTheme.darkGreen,
                         ),
                       ),
                     ),

                      // Order Type Selector
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        child: Column(
                          children: [
                            // Show Restaurant/Pickup selector only when split mode is OFF
                            if (!_isSplitMode)
                              SizedBox(
                                width: double.infinity,
                                child: CupertinoSlidingSegmentedControl<ReservationOrderType>(
                                  groupValue: _selectedOrderType,
                                  children: const {
                                    ReservationOrderType.restaurant: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                      child: Text('Restaurant'),
                                    ),
                                    ReservationOrderType.pickup: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                      child: Text('Pickup'),
                                    ),
                                  },
                                  onValueChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedOrderType = value);
                                    }
                                  },
                                ),
                              ),
                            
                            // Show split delivery toggle when quantity >= 2
                            if (_quantity >= 2) ...[
                              if (!_isSplitMode) const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Text(
                                    'Split Delivery',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  CupertinoSwitch(
                                    value: _isSplitMode,
                                    activeColor: AppTheme.darkGreen,
                                    onChanged: (value) {
                                      setState(() {
                                        _isSplitMode = value;
                                        if (value) {
                                          // Initialize split with all to restaurant
                                          _restaurantQuantity = _quantity;
                                          _pickupQuantity = 0;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              
                              // Show split UI when toggle is ON
                              if (_isSplitMode) ...[
                                const SizedBox(height: 16),
                                _buildSplitDeliverySelector(),
                              ],
                            ],
                          ],
                        ),
                      ),
                   ],
                 ),
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
                     borderRadius: AppTheme.cardRadius,
                   ),
                   child: Row(
                     children: [
                       CupertinoButton(
                         padding: const EdgeInsets.symmetric(horizontal: 12),
                         onPressed: _decrement,
                          child: const Text('-', style: TextStyle(fontSize: 24, color: AppTheme.darkGreen)),
                       ),
                       Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                       CupertinoButton(
                         padding: const EdgeInsets.symmetric(horizontal: 12),
                         onPressed: _increment,
                          child: const Text('+', style: TextStyle(fontSize: 24, color: AppTheme.darkGreen)),
                       ),
                     ],
                   ),
                 ),
                 const SizedBox(width: 16),
                 // Action Button
                 Expanded(
                   child: CupertinoButton(
                     color: buttonColor,
                     borderRadius: AppTheme.cardRadius,
                     onPressed: () async {
                        await _submitOrder();
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
   
   // Split Delivery Selector Widget (shown when toggle is ON)
   Widget _buildSplitDeliverySelector() {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         // Restaurant Row
         _buildDeliveryTypeRow(
           label: 'Restaurant',
           quantity: _restaurantQuantity,
           color: AppTheme.restaurantColor,
           onIncrement: _incrementRestaurant,
           onDecrement: _decrementRestaurant,
         ),
         const SizedBox(height: 12),
         
         // Pickup Row
         _buildDeliveryTypeRow(
           label: 'Pickup',
           quantity: _pickupQuantity,
           color: AppTheme.pickupColor,
           onIncrement: _incrementPickup,
           onDecrement: _decrementPickup,
         ),
       ],
     );
   }
   
   Widget _buildDeliveryTypeRow({
     required String label,
     required int quantity,
     required Color color,
     required VoidCallback onIncrement,
     required VoidCallback onDecrement,
   }) {
     final double price = widget.item.price * quantity;
     
     return Container(
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(
         color: color.withOpacity(0.1),
         borderRadius: AppTheme.cardRadius,
         border: Border.all(
           color: color.withOpacity(0.3),
           width: 1,
         ),
       ),
       child: Row(
         children: [
           // Color indicator
           Container(
             width: 4,
             height: 40,
             decoration: BoxDecoration(
               color: color,
               borderRadius: BorderRadius.circular(2),
             ),
           ),
           const SizedBox(width: 12),
           
           // Label
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   label,
                   style: const TextStyle(
                     fontSize: 15,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
                 Text(
                   '€${price.toStringAsFixed(2)}',
                   style: TextStyle(
                     fontSize: 13,
                     color: color,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
               ],
             ),
           ),
           
           // Quantity controls
           Container(
             decoration: BoxDecoration(
               color: CupertinoColors.systemBackground,
               borderRadius: BorderRadius.circular(8),
             ),
             child: Row(
               children: [
                 CupertinoButton(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                   onPressed: quantity > 0 ? onDecrement : null,
                   child: Icon(
                     CupertinoIcons.minus,
                     size: 18,
                     color: quantity > 0 ? AppTheme.darkGreen : CupertinoColors.systemGrey3,
                   ),
                 ),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12),
                   child: Text(
                     '$quantity',
                     style: const TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                 ),
                 CupertinoButton(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                   onPressed: onIncrement,
                   child: const Icon(
                     CupertinoIcons.plus,
                     size: 18,
                     color: AppTheme.darkGreen,
                   ),
                 ),
               ],
             ),
           ),
         ],
       ),
     );
   }
   
   // Unified order submission
   Future<void> _submitOrder() async {
     final isInCart = _initialCartQuantity > 0;
     final hasChanges = _hasChanges();
     
     if (isInCart && !hasChanges) {
       // Remove all orders
       await _removeAllOrders();
     } else {
       // Add or Update
       if (isInCart) {
         // Remove existing first
         await _removeAllOrders();
         await Future.delayed(const Duration(milliseconds: 100));
       }
       
       // Add new orders based on current state
       if (_isSplitMode) {
         await _addSplitOrders();
       } else {
         await _addSingleOrder();
       }
     }
   }
   
   Future<void> _removeAllOrders() async {
     ref.read(apiReservationRepositoryProvider.notifier).removeReservation(
       foodItemId: widget.item.id,
     );
   }
   
   Future<void> _addSplitOrders() async {
     if (_restaurantQuantity > 0) {
       ref.read(apiReservationRepositoryProvider.notifier).addReservation(
         userId: 'current_user',
         foodItemId: widget.item.id,
         foodName: widget.item.name,
         date: DateTime.now(),
         price: widget.item.price,
         quantity: _restaurantQuantity,
         orderType: 'restaurant',
       );
     }
     
     if (_pickupQuantity > 0) {
       ref.read(apiReservationRepositoryProvider.notifier).addReservation(
         userId: 'current_user',
         foodItemId: widget.item.id,
         foodName: widget.item.name,
         date: DateTime.now(),
         price: widget.item.price,
         quantity: _pickupQuantity,
         orderType: 'pickup',
       );
     }
   }
   
   Future<void> _addSingleOrder() async {
     ref.read(apiReservationRepositoryProvider.notifier).addReservation(
       userId: 'current_user',
       foodItemId: widget.item.id,
       foodName: widget.item.name,
       date: DateTime.now(),
       price: widget.item.price,
       quantity: _quantity,
       orderType: _selectedOrderType == ReservationOrderType.pickup ? 'pickup' : 'restaurant',
     );
   }
}
