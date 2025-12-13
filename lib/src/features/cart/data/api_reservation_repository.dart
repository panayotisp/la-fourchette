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
    // Load initial orders from backend
    // For now, return empty list - will implement user-specific loading
    return [];
  }

  Future<void> addReservation({
    required String userId,
    required String foodItemId,
    required String foodName,
    required DateTime date,
    required double price,
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
          'quantity': 1,
          'order_type': orderType,
        }),
      );

      if (response.statusCode == 201) {
        // Successfully created
        // TODO: Refresh state from server
        state = AsyncData([...state.value ?? []]);
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  Future<void> updateReservationQuantity({
    required String foodItemId,
    required int newQuantity,
  }) async {
    // TODO: Implement when we have order IDs in state
    final currentState = state.value ?? [];
    state = AsyncData(currentState);
  }

  Future<void> removeReservation({required String foodItemId}) async {
    // TODO: Implement when we have order IDs in state
    final currentState = state.value ?? [];
    state = AsyncData(currentState);
  }
}
