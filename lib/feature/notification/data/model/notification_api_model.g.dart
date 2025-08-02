// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationApiModel _$NotificationApiModelFromJson(
        Map<String, dynamic> json) =>
    NotificationApiModel(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      message: json['message'] as String,
      read: json['read'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationApiModelToJson(
        NotificationApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'message': instance.message,
      'read': instance.read,
      'createdAt': instance.createdAt.toIso8601String(),
    };
