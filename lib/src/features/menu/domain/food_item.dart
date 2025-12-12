import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final int? stock; // Optional: null means unlimited

  const FoodItem({
    required this.id,
    required this.name,
    this.description = '',
    required this.imageUrl,
    required this.price,
    this.stock,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl, price, stock];
}
