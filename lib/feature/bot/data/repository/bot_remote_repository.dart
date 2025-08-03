import 'package:dartz/dartz.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/bot/data/data_source/bot_data_source.dart';
import 'package:hamro_grocery_mobile/feature/bot/domain/entity/bot_entity.dart';
import 'package:hamro_grocery_mobile/feature/bot/domain/repository/bot_repository.dart';

class BotRepositoryImpl implements BotRepository {
  final BotDataSource remoteDataSource;

  BotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ChatMessageEntity>> getChatReply({
    required String query,
    required List<ChatMessageEntity> history,
  }) async {
    try {
      final responseModel = await remoteDataSource.getChatReply(
        query: query,
        history: history,
      );

      // The backend API returns the reply as a single string.
      // We wrap it in our domain entity.
      final botReplyEntity = ChatMessageEntity(
        role: ChatRole.model, // The reply is always from the 'model'
        text: responseModel.data.reply,
      );

      return Right(botReplyEntity);
    } on ApiFailure catch (e) {
      return Left(ApiFailure(statusCode: e.statusCode, message: e.message));
    }
  }
}
