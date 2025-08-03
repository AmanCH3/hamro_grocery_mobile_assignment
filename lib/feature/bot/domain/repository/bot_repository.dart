import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/bot/domain/entity/bot_entity.dart';

abstract interface class BotRepository {
  Future<Either<Failure, ChatMessageEntity>> getChatReply({
    required String query,
    required List<ChatMessageEntity> history,
  });
}
