import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/category/domain/entity/category_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? categoryId;
  final String name;

  const CategoryApiModel({this.categoryId, required this.name});

  const CategoryApiModel.empty() : categoryId = '', name = '';

  // From Json ,
  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    return CategoryApiModel(categoryId: json['_id'], name: json['name']);
  }

  // To Json
  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  CategoryEntity toEntity() =>
      CategoryEntity(categoryId: categoryId ?? '', name: name);

  // Convert Entity to API Object
  static CategoryApiModel fromEntity(CategoryEntity entity) =>
      CategoryApiModel(categoryId: entity.categoryId, name: entity.name);

  // Convert API List to Entity List
  static List<CategoryEntity> toEntityList(List<CategoryApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [categoryId, name];
}
