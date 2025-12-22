import 'package:equatable/equatable.dart';

enum ReservationStatus { cart, completed, cancelled }

enum ReservationOrderType { restaurant, pickup }

class Reservation extends Equatable {
  final String id;
  final String userId; // Email
  final String? userName; // First name
  final String? userSurname; // Last name
  final String foodItemId;
  final String foodName; // store snapshot in case menu changes
  final DateTime date;
  final double price; // Store price per item
  final ReservationStatus status;

  final int quantity;
  final ReservationOrderType orderType;
  final bool delivered; // Delivery status for admin tracking

  const Reservation({
    required this.id,
    required this.userId,
    this.userName,
    this.userSurname,
    required this.foodItemId,
    required this.foodName,
    required this.date,
    required this.price,
    this.status = ReservationStatus.cart,
    this.quantity = 1,
    this.orderType = ReservationOrderType.restaurant,
    this.delivered = false,
  });

  @override
  List<Object?> get props => [id, userId, userName, userSurname, foodItemId, foodName, date, price, status, quantity, orderType, delivered];
}
