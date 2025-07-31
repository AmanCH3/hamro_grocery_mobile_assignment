import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_item_api.g.dart';

@JsonSerializable()
class OrderItemApiModel extends Equatable {
  @JsonKey(name: 'product')
  final String? productId;
  final int? quantity;
  final double? price;
  final String? name;
  final String? imageUrl;

  const OrderItemApiModel({
    this.productId,
    this.quantity,
    this.price,
    this.name,
    this.imageUrl,
  });

  // Let the generator handle the JSON conversion
  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemApiModelToJson(this);

  // Converts a single API model to a single Domain Entity
  OrderItem toEntity() => OrderItem(
    productId: productId ?? '',
    quantity: quantity ?? 0,
    price: price ?? 0.0,
    name: name ?? 'Unnamed Product',
    imageUrl: imageUrl ?? '',
  );

  // Converts a single Domain Entity to a single API model
  static OrderItemApiModel fromEntity(OrderItem entity) => OrderItemApiModel(
    productId: entity.productId,
    quantity: entity.quantity,
    price: entity.price,
    name: entity.name,
    imageUrl: entity.imageUrl,
  );

  // --- THIS IS THE MISSING METHOD THAT YOU NEED TO ADD ---
  /// Converts a list of API models to a list of Domain Entities.
  static List<OrderItem> toEntityList(List<OrderItemApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
  // ---------------------------------------------------------

  @override
  List<Object?> get props => [productId, quantity, price, name, imageUrl];
}
