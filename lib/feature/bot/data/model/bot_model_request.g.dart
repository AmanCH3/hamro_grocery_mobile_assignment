// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot_model_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRequestModel _$ChatRequestModelFromJson(Map<String, dynamic> json) =>
    ChatRequestModel(
      query: json['query'] as String,
      history: (json['history'] as List<dynamic>)
          .map((e) => HistoryMessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatRequestModelToJson(ChatRequestModel instance) =>
    <String, dynamic>{
      'query': instance.query,
      'history': instance.history.map((e) => e.toJson()).toList(),
    };

HistoryMessageModel _$HistoryMessageModelFromJson(Map<String, dynamic> json) =>
    HistoryMessageModel(
      role: json['role'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$HistoryMessageModelToJson(
        HistoryMessageModel instance) =>
    <String, dynamic>{
      'role': instance.role,
      'text': instance.text,
    };
