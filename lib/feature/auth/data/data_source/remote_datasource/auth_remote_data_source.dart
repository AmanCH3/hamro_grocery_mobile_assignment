// lib/feature/auth/data/data_source/auth_remote_data_source.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hamro_grocery_mobile/app/constant/api_endpoints.dart';
import 'package:hamro_grocery_mobile/common/image_utils.dart';
import 'package:hamro_grocery_mobile/common/profile_utils.dart';
import 'package:hamro_grocery_mobile/core/network/api_service.dart';
import 'package:hamro_grocery_mobile/feature/auth/data/data_source/auth_data_source.dart';
import 'package:hamro_grocery_mobile/feature/auth/data/model/user_api_model.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';

class AuthRemoteDataSource implements IAuthDataSource {
  final ApiService _apiService;

  // FIX: Changed constructor to accept a named parameter 'apiService'.
  AuthRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw Exception("Failed to login user : ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to Login user : ${e.message}");
    } catch (e) {
      throw Exception("failed to login user $e");
    }
  }

  // ... rest of your class code remains the same
  @override
  Future<void> registerUser(AuthEntity entity) async {
    try {
      final userApiModel = UserApiModel.fromEntity(entity);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );

      if (response.statusCode == 201) {
        // Typically 201 for creation
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
  Future<AuthEntity> getUserProfile(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getUserProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

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
  Future<AuthEntity> updateUserProfile(AuthEntity entity, String? token) async {
    try {
      ProfileUtils.logEntity('Entity being sent to updateUserProfile', entity);
      final userApiModel = UserApiModel.fromEntity(entity);
      final jsonData = userApiModel.toJson();

      final response = await _apiService.dio.put(
        ApiEndpoints.updateUserProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: jsonData,
      );
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
  Future<AuthEntity> updateProfilePicture(
    String imagePath,
    String? token,
  ) async {
    try {
      final formData = await ImageUtils.createImageFormData(
        imagePath,
        'profilePicture',
      );

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
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
        data: formData,
      );

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
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? 'Upload failed';
        } else {
          errorMessage = e.response?.statusMessage ?? 'Upload failed';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
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

  @override
  Future<void> changePassword(String oldPassword, String newPassword) {
    throw UnimplementedError();
  }

  @override
  Future<void> logoutUser() {
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword(String email) {
    throw UnimplementedError();
  }
}
