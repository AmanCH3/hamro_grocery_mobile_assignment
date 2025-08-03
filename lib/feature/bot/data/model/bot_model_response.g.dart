// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatResponseModel _$ChatResponseModelFromJson(Map<String, dynamic> json) =>
    ChatResponseModel(
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 500,
      data: _dataFromJson(json['data'] as Map<String, dynamic>?),
      message: json['message'] as String? ?? 'An unknown error occurred.',
    );

Map<String, dynamic> _$ChatResponseModelToJson(ChatResponseModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'data': instance.data.toJson(),
      'message': instance.message,
    };

ChatReplyDataModel _$ChatReplyDataModelFromJson(Map<String, dynamic> json) =>
    ChatReplyDataModel(
      reply: json['reply'] as String? ?? 'Sorry, no reply was found.',
    );

Map<String, dynamic> _$ChatReplyDataModelToJson(ChatReplyDataModel instance) =>
    <String, dynamic>{
      'reply': instance.reply,
    };
