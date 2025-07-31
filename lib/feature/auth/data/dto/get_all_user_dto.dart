import 'package:hamro_grocery_mobile/feature/auth/data/model/user_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_user_dto.g.dart';

@JsonSerializable()
class GetAllUserDto {
  final bool success;
  final int count;
  final List<UserApiModel> data;

  GetAllUserDto({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetAllUserDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllUserDtoToJson(this);

  List<UserApiModel> toUserApiModels() {
    return data
        .map((user) => UserApiModel.fromEntity(user.toEntity()))
        .toList();
  }
}
