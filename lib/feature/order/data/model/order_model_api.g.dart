// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderApiModel _$OrderApiModelFromJson(Map<String, dynamic> json) =>
    OrderApiModel(
      orderId: json['_id'] as String?,
      customer: json['customer'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      amount: (json['amount'] as num?)?.toDouble(),
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      transactionId: json['transactionId'] as String?,
      pointsAwarded: (json['pointsAwarded'] as num?)?.toInt(),
      discountApplied: json['discountApplied'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$OrderApiModelToJson(OrderApiModel instance) =>
    <String, dynamic>{
      '_id': instance.orderId,
      'customer': instance.customer,
      'items': instance.items,
      'amount': instance.amount,
      'address': instance.address,
      'phone': instance.phone,
      'status': instance.status,
      'paymentMethod': instance.paymentMethod,
      'transactionId': instance.transactionId,
      'pointsAwarded': instance.pointsAwarded,
      'discountApplied': instance.discountApplied,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
