import 'package:dio/dio.dart';
import 'package:hamro_grocery_mobile/app/constant/api_endpoints.dart';
import 'package:hamro_grocery_mobile/core/network/api_service.dart';
import 'package:hamro_grocery_mobile/feature/category/data/data_source/category_data_source.dart';
import 'package:hamro_grocery_mobile/feature/category/data/dto/get_all_category_dto.dart';
import 'package:hamro_grocery_mobile/feature/category/data/model/category_api_model.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';

class CategoryRemoteDataSource implements ICategoryDataSource {
  final ApiService _apiService;

  CategoryRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getAllCategories);
      if (response.statusCode == 200) {
        GetAllCategoryDto getAllCategoryDto = GetAllCategoryDto.fromJson(
          response.data,
        );
        return CategoryApiModel.toEntityList(getAllCategoryDto.data);
      } else {
        throw Exception('Failed to load categories');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch categories: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}