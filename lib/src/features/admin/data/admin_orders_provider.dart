import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../cart/domain/reservation.dart';
import '../../../config/api_config.dart';

part 'admin_orders_provider.g.dart';

@riverpod
class AdminOrders extends _$AdminOrders {
  @override
  Future<List<Reservation>> build() async {
    return _fetchAllOrders();
  }

  Future<List<Reservation>> _fetchAllOrders() async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.ordersEndpoint}/admin/all');
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
            userName: json['user_name'],
            userSurname: json['user_surname'],
            foodItemId: json['schedule_id'],
            foodName: json['food_name'] ?? json['food_name_en'],
            date: DateTime.parse(json['menu_date']),
            price: (json['price'] as num).toDouble(),
            quantity: json['quantity'] as int,
            status: json['status'] == 'cart' ? ReservationStatus.cart : ReservationStatus.completed,
            orderType: json['order_type'] == 'pickup' ? ReservationOrderType.pickup : ReservationOrderType.restaurant,
            delivered: json['delivered'] == 1 || json['delivered'] == true,
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  void refresh() {
    ref.invalidateSelf();
  }

  Future<void> updateDeliveryStatus(String orderId, bool delivered) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.ordersEndpoint}/$orderId/delivery-status');
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'delivered': delivered}),
      );

      if (response.statusCode == 200) {
        ref.invalidateSelf(); // Refresh data after update
      }
    } catch (e) {
      // Handle error silently or log it
    }
  }
}
