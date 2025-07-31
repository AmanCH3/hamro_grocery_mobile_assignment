import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';

abstract interface class IProductDataSource {
  Future<List<ProductEntity>> getAllProducts();
}
