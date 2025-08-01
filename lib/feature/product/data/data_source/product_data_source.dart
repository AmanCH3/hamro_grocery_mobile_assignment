import 'package:hamro_grocery_mobile/feature/product/data/model/product_api_model.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';

abstract interface class IProductDataSource {
  Future<List<ProductEntity>> getAllProducts();
  Future<List<ProductApiModel>> getProductsByCategory(String categoryName);
}
