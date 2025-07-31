import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/category/data/model/category_api_model.dart';
import 'package:hamro_grocery_mobile/feature/product/domain/entity/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_api_model.g.dart';

@JsonSerializable()
class ProductApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? productId;
  final String? name;
  final CategoryApiModel? category;
  final double? price;
  final int? stock;
  final String? imageUrl;

  const ProductApiModel({
    this.productId,
    this.name,
    this.category,
    this.price,
    this.stock,
    this.imageUrl,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductApiModelToJson(this);

  ProductEntity toEntity() {
    return ProductEntity(
      productId: productId,
      name: name,
      category: category?.toEntity(),
      price: price,
      stock: stock,
      imageUrl: imageUrl,
    );
  }

  static ProductApiModel fromEntity(ProductEntity entity) {
    return ProductApiModel(
      productId: entity.productId,
      name: entity.name,
      category:
          entity.category != null
              ? CategoryApiModel.fromEntity(entity.category!)
              : null,
      price: entity.price,
      stock: entity.stock,
      imageUrl: entity.imageUrl,
    );
  }

  static List<ProductEntity> toEntityList(List<ProductApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    category,
    price,
    stock,
    imageUrl,
  ];
}
