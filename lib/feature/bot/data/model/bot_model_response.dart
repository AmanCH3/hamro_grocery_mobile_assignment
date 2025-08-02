import 'package:json_annotation/json_annotation.dart';

part 'bot_model_response.g.dart';

ChatReplyDataModel _dataFromJson(Map<String, dynamic>? json) {
  if (json == null) {
    return const ChatReplyDataModel(
      reply: 'Sorry, I could not get a response.',
    );
  }
  return ChatReplyDataModel.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class ChatResponseModel {
  @JsonKey(defaultValue: 500)
  final int statusCode;

  // Use the custom fromJson helper function here
  @JsonKey(name: 'data', fromJson: _dataFromJson)
  final ChatReplyDataModel data;

  @JsonKey(defaultValue: 'An unknown error occurred.')
  final String message;

  ChatResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatResponseModelToJson(this);
}

@JsonSerializable()
class ChatReplyDataModel {
  @JsonKey(defaultValue: 'Sorry, no reply was found.')
  final String reply;

  // It's good practice to keep the const constructor
  const ChatReplyDataModel({required this.reply});

  factory ChatReplyDataModel.fromJson(Map<String, dynamic> json) =>
      _$ChatReplyDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatReplyDataModelToJson(this);
}
