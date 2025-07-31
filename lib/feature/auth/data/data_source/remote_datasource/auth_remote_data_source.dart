import 'package:dio/dio.dart';
import 'package:hamro_grocery_mobile/app/constant/api_endpoints.dart';
import 'package:hamro_grocery_mobile/core/network/api_service.dart';
import 'package:hamro_grocery_mobile/feature/auth/data/data_source/auth_data_source.dart';
import 'package:hamro_grocery_mobile/feature/auth/data/dto/get_all_user_dto.dart';
import 'package:hamro_grocery_mobile/feature/auth/data/model/user_api_model.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';

class AuthRemoteDataSource implements IAuthDataSource {
  final ApiService _apiService;
  AuthRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      print('user response $response');
      if (response.statusCode == 200) {
        final str = response.data['token'];
        return str;
      } else {
        throw Exception("Failed to login user : ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to Login user : ${e.message}");
    } catch (e) {
      throw Exception("failed to login user $e");
    }
  }

  @override
  Future<void> registerUser(AuthEntity entity) async {
    try {
      final userApiModel = UserApiModel.fromEntity(entity);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      print('register response : $response');
      print("api endpoints fixed${ApiEndpoints.register}");

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to register user : ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to register user : ${e.message}");
    } catch (e) {
      throw Exception('Failed to register student : $e');
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<AuthEntity> getUserProfile(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getUserProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('get user profile response : $response');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final Map<String, dynamic> userJson = response.data['data'];
        final userApiModel = UserApiModel.fromJson(userJson);
        return userApiModel.toEntity();
      } else {
        // Throw an exception with the server's message if available.
        final errorMessage = response.data['message'] ?? response.statusMessage;
        throw Exception("Failed to get user profile: $errorMessage");
      }
    } on DioException catch (e) {
      // Propagate a more specific error message from Dio.
      throw Exception("Failed to get user profile: ${e.message}");
    } catch (e) {
      // Catch any other unexpected errors, like the parsing error you were seeing.
      throw Exception("An unexpected error occurred while getting profile: $e");
    }
  }

  @override
  Future<void> logoutUser() {
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword(String email) {
    throw UnimplementedError();
  }

  @override
  Future<AuthEntity> updateUserProfile(AuthEntity entity, String? token) async {
    try {
      final userApiModel = UserApiModel.fromEntity(entity);
      final response = await _apiService.dio.put(
        ApiEndpoints.updateUserProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: userApiModel.toJson(),
      );
      print('update user profile response : $response');
      if (response.statusCode == 200) {
        final updatedUserJson = response.data['data'] ?? response.data;
        final updatedUserApiModel = UserApiModel.fromJson(updatedUserJson);
        return updatedUserApiModel.toEntity();
      } else {
        throw Exception(
          "Failed to update user profile: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw Exception("Failed to update user profile: ${e.message}");
    } catch (e) {
      throw Exception("Failed to update user profile: $e");
    }
  }
}
