import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/app/usecase/usecase.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/feature/bot/domain/entity/bot_entity.dart';
import 'package:hamro_grocery_mobile/feature/bot/domain/repository/bot_repository.dart';

class GetChatReplyUsecase
    implements UseCaseWithParams<ChatMessageEntity, GetChatReplyParams> {
  final BotRepository repository;

  GetChatReplyUsecase(this.repository);

  @override
  Future<Either<Failure, ChatMessageEntity>> call(
    GetChatReplyParams params,
  ) async {
    return await repository.getChatReply(
      query: params.query,
      history: params.history,
    );
  }
}

// Parameters class for the usecase
class GetChatReplyParams extends Equatable {
  final String query;
  final List<ChatMessageEntity> history;

  const GetChatReplyParams({required this.query, required this.history});

  @override
  List<Object?> get props => [query, history];
}
