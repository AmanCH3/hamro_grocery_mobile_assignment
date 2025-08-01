import 'package:dio/dio.dart';
import 'package:hamro_grocery_mobile/app/constant/api_endpoints.dart';
import 'package:hamro_grocery_mobile/core/network/api_service.dart';
import 'package:hamro_grocery_mobile/feature/auth/data/data_source/auth_data_source.dart';
import 'package:hamro_grocery_mobile/feature/auth/data/dto/get_all_user_dto.dart';
import 'package:hamro_grocery_mobile/feature/auth/data/model/user_api_model.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';
import 'package:hamro_grocery_mobile/common/image_utils.dart';
import 'package:hamro_grocery_mobile/common/profile_utils.dart';
import 'dart:io';

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
        final errorMessage = response.data['message'] ?? response.statusMessage;
        throw Exception("Failed to get user profile: $errorMessage");
      }
    } on DioException catch (e) {
      throw Exception("Failed to get user profile: ${e.message}");
    } catch (e) {
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
      // Debug logging
      ProfileUtils.logEntity('Entity being sent to updateUserProfile', entity);
      
      final userApiModel = UserApiModel.fromEntity(entity);
      final jsonData = userApiModel.toJson();
      print('update user profile request data: $jsonData');
      print('profilePicture in request: ${jsonData['profilePicture']}');
      
      final response = await _apiService.dio.put(
        ApiEndpoints.updateUserProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: jsonData,
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

  @override
  Future<AuthEntity> updateProfilePicture(String imagePath, String? token) async {
    try {
      // Use ImageUtils to validate and create FormData
      final formData = await ImageUtils.createImageFormData(imagePath, 'profilePicture');
      
      if (formData == null) {
        throw Exception("Failed to create form data for image upload");
      }

      final response = await _apiService.dio.put(
        ApiEndpoints.updateUserProfilePicture,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          // Increase timeout for file uploads
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
        data: formData,
      );

      print('update profile picture response: $response');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final updatedUserJson = response.data['data'];
        final updatedUserApiModel = UserApiModel.fromJson(updatedUserJson);
        return updatedUserApiModel.toEntity();
      } else {
        final errorMessage = response.data['message'] ?? response.statusMessage;
        throw Exception("Failed to update profile picture: $errorMessage");
      }
    } on DioException catch (e) {
      String errorMessage;
      
      if (e.response != null) {
        // Server responded with error
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? 'Upload failed';
        } else {
          errorMessage = e.response?.statusMessage ?? 'Upload failed';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Upload timeout. Please try again.';
      } else {
        errorMessage = e.message ?? 'Upload failed';
      }
      
      throw Exception("Failed to update profile picture: $errorMessage");
    } catch (e) {
      throw Exception("Failed to update profile picture: $e");
    }
  }
}

  // @override
  // Future<AuthEntity> updateProfilePicture(
  //   String imagePath,
  //   String? token,
  // )  {
  //   try {
  //   //   // The key 'profilePicture' MUST match multerUpload.single('profilePicture') in your route.
  //   //   String fileName = imagePath.split('/').last;
  //   //   FormData formData = FormData.fromMap({
  //   //     'profilePicture': await MultipartFile.fromFile(
  //   //       imagePath,
  //   //       filename: fileName,
  //   //     ),
  //   //   });
  //   //   final response = await apiService.dio.put(
  //   //     ApiEndpoints
  //   //         .updateUserProfilePicture, // Uses the '/profile/picture' endpoint
  //   //     options: Options(headers: {'Authorization': 'Bearer $token'}),
  //   //     data: formData,
  //   //   );

  //   //   if (response.statusCode == 200) {
  //   //     final updatedUserJson = response.data['data'] ?? response.data;
  //   //     return UserApiModel.fromJson(updatedUserJson).toEntity();
  //   //   } else {
  //   //     throw Exception("Failed to update picture: ${response.statusMessage}");
  //   //   }
  //   // } on DioException catch (e) {
  //   //   throw Exception(
  //   //     "Failed to update picture: ${e.response?.data['message'] ?? e.message}",
  //   //   );
  //   // }
  //   }
  // }

