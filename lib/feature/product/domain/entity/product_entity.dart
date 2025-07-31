import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';

class ProductEntity extends Equatable {
  final String? productId;
  final String? name;
  final CategoryEntity? category;
  final double? price;
  final int? stock;
  final String? imageUrl;

  const ProductEntity({
    this.productId,
    this.name,
    this.category,
    this.price,
    this.stock,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    productId,
    name,
    category,
    price,
    imageUrl,
    stock,
  ];
}
