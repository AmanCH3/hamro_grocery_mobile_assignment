import 'package:dio/dio.dart';
import 'package:hamro_grocery_mobile/app/constant/api_endpoints.dart';
import 'package:hamro_grocery_mobile/core/error/failure.dart';
import 'package:hamro_grocery_mobile/core/network/api_service.dart';
import 'package:hamro_grocery_mobile/feature/product/data/data_source/product_data_source.dart';
import 'package:hamro_grocery_mobile/feature/product/data/dto/get_all_product_dto.dart';
import 'package:hamro_grocery_mobile/feature/product/data/model/product_api_model.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';

class ProductRemoteDataSource implements IProductDataSource {
  final ApiService _apiService;

  ProductRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getAllProducts);

      if (response.statusCode == 200) {
        final List<dynamic> productJsonList = response.data as List<dynamic>;
        final List<ProductApiModel> productModels =
            productJsonList
                .map(
                  (json) =>
                      ProductApiModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();
        return ProductApiModel.toEntityList(productModels);
      } else {
        throw Exception(
          'Failed to load products with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // It's good practice to re-throw with more context, as you've done.
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<List<ProductApiModel>> getProductsByCategory(
    String categoryName,
  ) async {
    try {
      // Use the new endpoint function to build the URL
      final response = await _apiService.dio.get(
        ApiEndpoints.getProductsByCategory(categoryName),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => ProductApiModel.fromJson(json)).toList();
      } else {
        // You could add more specific error handling here based on status code
        throw ApiFailure(message: '');
      }
    } on DioException catch (e) {
      // If the category is not found, the backend returns a 404
      if (e.response?.statusCode == 404) {
        // Return an empty list for a "not found" category
        return [];
      }
      throw ApiFailure(message: '');
    } catch (e) {
      throw ApiFailure(message: '');
    }
  }
}
