import 'package:equatable/equatable.dart';

enum ReservationStatus { confirmed, cancelled }

class Reservation extends Equatable {
  final String id;
  final String userId; // For now just distinct ID
  final String foodItemId;
  final String foodName; // store snapshot in case menu changes
  final DateTime date;
  final ReservationStatus status;

  const Reservation({
    required this.id,
    required this.userId,
    required this.foodItemId,
    required this.foodName,
    required this.date,
    this.status = ReservationStatus.confirmed,
  });

  @override
  List<Object?> get props => [id, userId, foodItemId, foodName, date, status];
}
