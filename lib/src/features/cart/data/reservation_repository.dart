import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../domain/reservation.dart';

part 'reservation_repository.g.dart';

@Riverpod(keepAlive: true)
class ReservationRepository extends _$ReservationRepository {
  final List<Reservation> _mockReservations = []; // In-memory store
  final _uuid = const Uuid();

  @override
  Future<List<Reservation>> build() async {
    return _mockReservations;
  }

  Future<void> addReservation({
    required String userId,
    required String foodItemId,
    required String foodName,
    required DateTime date,
    required double price,
  }) async {
    final reservation = Reservation(
      id: _uuid.v4(),
      userId: userId,
      foodItemId: foodItemId,
      foodName: foodName,
      date: date,
      price: price,
    );
    
    _mockReservations.add(reservation);
    
    // Update state
    state = AsyncData([..._mockReservations]);
  }

  Future<void> updateReservationQuantity({
    required String userId,
    required String foodItemId,
    required String foodName,
    required DateTime date,
    required double price,
    required int newQuantity,
  }) async {
    // 1. Remove existing for this item
    _mockReservations.removeWhere((r) => r.foodItemId == foodItemId && r.status == ReservationStatus.confirmed);

    // 2. Add new quantity
    if (newQuantity > 0) {
      for (int i = 0; i < newQuantity; i++) {
        _mockReservations.add(Reservation(
          id: _uuid.v4(),
          userId: userId,
          foodItemId: foodItemId,
          foodName: foodName,
          date: date,
          price: price,
        ));
      }
    }

    // 3. Update state
    state = AsyncData([..._mockReservations]);
  }

  Future<void> removeReservation({required String foodItemId}) async {
    _mockReservations.removeWhere((r) => r.foodItemId == foodItemId && r.status == ReservationStatus.confirmed);
    state = AsyncData([..._mockReservations]);
  }

  Future<Map<String, int>> getReservationCounts() async {
     // Returns map of FoodName -> Count
     final counts = <String, int>{};
     for (var res in _mockReservations) {
       if (res.status == ReservationStatus.confirmed) {
         counts[res.foodName] = (counts[res.foodName] ?? 0) + 1;
       }
     }
     return counts;
  }
}
