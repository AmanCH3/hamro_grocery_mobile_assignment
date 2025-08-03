import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hamro_grocery_mobile/app/constant/api_endpoints.dart';
import 'package:hamro_grocery_mobile/app/shared_pref/token_shared_pref.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/core/network/api_service.dart';
import 'package:hamro_grocery_mobile/feature/notification/data/model/notification_api_model.dart';

class NotificationRemoteDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs _tokenSharedPrefs;

  NotificationRemoteDataSource(this._apiService, this._tokenSharedPrefs);

  Future<Either<Failure, List<NotificationApiModel>>> getNotifications() async {
    try {
      final tokenResult = await _tokenSharedPrefs.getToken();
      return tokenResult.fold((failure) => Left(failure), (token) async {
        if (token == null) {
          return Left(ApiFailure(message: 'User not authenticated.'));
        }

        // CORRECTED LINE
        final response = await _apiService.dio.get(
          ApiEndpoints.notifications,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['data'];
          final notifications =
              data
                  .map<NotificationApiModel>(
                    (json) => NotificationApiModel.fromJson(json),
                  )
                  .toList();
          return Right(notifications);
        } else {
          return Left(
            ApiFailure(
              message:
                  response.data['message'] ?? 'Failed to get notifications.',
              statusCode: response.statusCode,
            ),
          );
        }
      });
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? e.message ?? 'Unknown error',
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, bool>> markAsRead() async {
    try {
      final tokenResult = await _tokenSharedPrefs.getToken();
      return tokenResult.fold((failure) => Left(failure), (token) async {
        if (token == null) {
          return Left(ApiFailure(message: 'User not authenticated.'));
        }

        // CORRECTED LINE
        final response = await _apiService.dio.put(
          ApiEndpoints.markNotificationsAsRead,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.statusCode == 200) {
          return const Right(true);
        } else {
          return Left(
            ApiFailure(
              message: response.data['message'] ?? 'Failed to mark as read.',
              statusCode: response.statusCode,
            ),
          );
        }
      });
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? e.message ?? 'Unknown error',
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
