import 'package:json_annotation/json_annotation.dart';

part 'notification_api_model.g.dart';

@JsonSerializable()
class NotificationApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String userId;
  final String message;
  final bool read;
  final DateTime createdAt;

  NotificationApiModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationApiModelToJson(this);
}