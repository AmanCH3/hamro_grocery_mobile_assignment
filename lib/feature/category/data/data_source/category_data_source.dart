import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';

abstract interface class ICategoryDataSource {
  Future<List<CategoryEntity>> getAllCategories();
}
