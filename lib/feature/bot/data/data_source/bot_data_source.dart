import 'package:hamro_grocery_mobile/feature/bot/data/model/bot_model_response.dart';
import 'package:hamro_grocery_mobile/feature/bot/domain/entity/bot_entity.dart';

abstract interface class BotDataSource {
  Future<ChatResponseModel> getChatReply({
    required String query,
    required List<ChatMessageEntity> history,
  });
}
