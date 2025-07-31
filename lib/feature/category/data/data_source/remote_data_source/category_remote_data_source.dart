import 'package:dio/dio.dart';
import 'package:hamro_grocery_mobile/app/constant/api_endpoints.dart';
import 'package:hamro_grocery_mobile/core/network/api_service.dart';
import 'package:hamro_grocery_mobile/feature/category/data/data_source/category_data_source.dart';
// We don't need the DTO anymore for this direct list response
// import 'package:hamro_grocery_mobile/feature/category/data/dto/get_all_category_dto.dart';
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
        // --- FIX IS HERE ---

        // 1. The response.data is a List of JSON objects. Cast it to List<dynamic>.
        final List<dynamic> jsonList = response.data;

        // 2. Use .map() to iterate over the list. For each JSON object in the list,
        //    create a CategoryApiModel instance from it.
        final List<CategoryApiModel> categoryApiModels =
            jsonList.map((json) => CategoryApiModel.fromJson(json)).toList();

        // 3. Convert the list of api models to a list of entities for your domain layer.
        return CategoryApiModel.toEntityList(categoryApiModels);
      } else {
        throw Exception('Failed to load categories');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch categories: ${e.message}');
    } catch (e) {
      // It's helpful to print the original error for better debugging
      print('Parsing Error: $e');
      throw Exception('Failed to parse categories: $e');
    }
  }
}
