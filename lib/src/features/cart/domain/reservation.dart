import 'package:equatable/equatable.dart';

enum ReservationStatus { pending, confirmed, cancelled }

enum ReservationOrderType { restaurant, toGo }

class Reservation extends Equatable {
  final String id;
  final String userId; // For now just distinct ID
  final String foodItemId;
  final String foodName; // store snapshot in case menu changes
  final DateTime date;
  final double price; // Store price per item
  final ReservationStatus status;

  final int quantity;
  final ReservationOrderType orderType;

  const Reservation({
    required this.id,
    required this.userId,
    required this.foodItemId,
    required this.foodName,
    required this.date,
    required this.price,
    this.status = ReservationStatus.pending,
    this.quantity = 1,
    this.orderType = ReservationOrderType.restaurant,
  });

  @override
  List<Object?> get props => [id, userId, foodItemId, foodName, date, price, status, quantity, orderType];
}
