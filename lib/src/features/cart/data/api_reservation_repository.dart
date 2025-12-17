import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../cart/domain/reservation.dart';
import '../../../config/api_config.dart';

part 'api_reservation_repository.g.dart';

@Riverpod(keepAlive: true)
class ApiReservationRepository extends _$ApiReservationRepository {
  @override
  Future<List<Reservation>> build() async {
    return _fetchUserOrders('current_user'); // TODO: Use real user ID
  }

  Future<List<Reservation>> _fetchUserOrders(String userId) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.ordersEndpoint}?user_email=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<Reservation>((json) {
           String imageUrl = json['image_url'] ?? '';
           if (imageUrl.startsWith('/')) {
              imageUrl = '${ApiConfig.baseUrl}$imageUrl';
           }
           
           return Reservation(
             id: json['id'],
             userId: json['user_email'],
             foodItemId: json['schedule_id'],
             foodName: json['food_name'] ?? json['food_name_en'], // Prefer Greek (imported name)
             date: DateTime.parse(json['menu_date']),
             price: (json['price'] as num).toDouble(),
             quantity: json['quantity'] as int,
             status: json['status'] == 'cart' ? ReservationStatus.pending : ReservationStatus.confirmed, 
             orderType: json['order_type'] == 'pickup' ? ReservationOrderType.pickup : ReservationOrderType.restaurant,
           );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addReservation({
    required String userId,
    required String foodItemId,
    required String foodName,
    required DateTime date,
    required double price,
    int quantity = 1,
    String userName = 'John',
    String userSurname = 'Doe',
    String orderType = 'restaurant',
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.ordersEndpoint}');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_email': userId,
          'user_name': userName,
          'user_surname': userSurname,
          'schedule_id': foodItemId,
          'quantity': quantity,
          'order_type': orderType,
        }),
      );

      if (response.statusCode == 201) {
        // Refresh state to get the new ID and data from server
        ref.invalidateSelf(); 
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  Future<void> updateReservation({
    required String userId,
    required String foodItemId, 
    required String foodName, // Unused but kept for signature compatibility if needed
    required DateTime date,   // Unused
    required double price,    // Unused
    required int newQuantity,
    required String newOrderType,
  }) async {
    // 1. Find the order ID for this food item in our current state
    final currentReservations = state.value ?? [];
    
    try {
      final reservation = currentReservations.firstWhere(
        (r) => r.foodItemId == foodItemId,
        orElse: () => throw Exception('Order not found in local state'),
      );
      
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.ordersEndpoint}/${reservation.id}');
      
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'quantity': newQuantity,
          'order_type': newOrderType,
        }),
      );

      if (response.statusCode == 200) {
        ref.invalidateSelf();
      } else {
        throw Exception('Failed to update order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating order: $e');
    }
  }

  Future<void> removeReservation({required String foodItemId}) async {
    // 1. Find the order ID
    final currentReservations = state.value ?? [];
    try {
      final reservation = currentReservations.firstWhere(
        (r) => r.foodItemId == foodItemId,
        orElse: () => throw Exception('Order not found in local state'),
      );

      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.ordersEndpoint}/${reservation.id}');
      
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        ref.invalidateSelf();
      } else {
         throw Exception('Failed to delete order: ${response.statusCode}');
      }
    } catch (e) {
      // If not found locally, maybe it's already gone, just refresh to be safe
      ref.invalidateSelf();
    }
  }

  Future<void> checkout(String userId) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.ordersEndpoint}/checkout');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_email': userId}),
      );

      if (response.statusCode == 200) {
        // Refresh local state (cart should become empty)
        ref.invalidateSelf(); 
      } else {
        throw Exception('Failed to checkout: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error checking out: $e');
    }
  }
}
