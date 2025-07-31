// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemApiModel _$OrderItemApiModelFromJson(Map<String, dynamic> json) =>
    OrderItemApiModel(
      productId: json['product'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$OrderItemApiModelToJson(OrderItemApiModel instance) =>
    <String, dynamic>{
      'product': instance.productId,
      'quantity': instance.quantity,
      'price': instance.price,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
    };
