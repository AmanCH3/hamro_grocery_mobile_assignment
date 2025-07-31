import 'package:hamro_grocery_mobile/feature/product/data/model/product_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_product_dto.g.dart';

@JsonSerializable()
class GetAllProductDto {
  final bool success;
  final int count;
  final List<ProductApiModel> data;

  const GetAllProductDto({
    required this.success,
    required this.count,
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetAllProductDtoToJson(this);

  factory GetAllProductDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllProductDtoFromJson(json);
}
