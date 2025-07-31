import 'package:hamro_grocery_mobile/feature/category/data/model/category_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_category_dto.g.dart';

@JsonSerializable()
class GetAllCategoryDto {
  final bool success;
  final int count;
  final List<CategoryApiModel> data;

  const GetAllCategoryDto({
    required this.success,
    required this.count,
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetAllCategoryDtoToJson(this);

  factory GetAllCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllCategoryDtoFromJson(json);
}
