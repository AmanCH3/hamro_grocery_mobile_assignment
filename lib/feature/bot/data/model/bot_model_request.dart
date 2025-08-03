import 'package:hamro_grocery_mobile/feature/bot/domain/entity/bot_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bot_model_request.g.dart';

@JsonSerializable(
  explicitToJson: true,
) // explicitToJson is crucial for nested lists
class ChatRequestModel {
  final String query;
  final List<HistoryMessageModel> history;

  ChatRequestModel({required this.query, required this.history});

  // This factory constructor lets the generator create an instance FROM JSON.
  factory ChatRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRequestModelFromJson(json);

  // This method lets the generator create JSON FROM the instance.
  Map<String, dynamic> toJson() => _$ChatRequestModelToJson(this);

  // --- Your custom logic remains unchanged ---
  factory ChatRequestModel.fromEntities({
    required String query,
    required List<ChatMessageEntity> historyEntities,
  }) {
    return ChatRequestModel(
      query: query,
      history:
          historyEntities
              .map((entity) => HistoryMessageModel.fromEntity(entity))
              .toList(),
    );
  }
}

// NOTE: It's better to make this a public, serializable class.
@JsonSerializable()
class HistoryMessageModel {
  final String role;
  final String text;

  HistoryMessageModel({required this.role, required this.text});

  // --- Generator methods ---
  factory HistoryMessageModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryMessageModelToJson(this);

  // --- Your custom logic remains unchanged ---
  factory HistoryMessageModel.fromEntity(ChatMessageEntity entity) {
    return HistoryMessageModel(
      role: entity.role.name, // .name converts enum to string
      text: entity.text,
    );
  }
}
