  // In your user_api_model.dart file

  import 'package:equatable/equatable.dart';
  import 'package:json_annotation/json_annotation.dart';
  import '../../domain/entity/auth_entity.dart';

  part 'user_api_model.g.dart';

  @JsonSerializable()
  class UserApiModel extends Equatable {
    @JsonKey(name: '_id', includeIfNull: false)
    final String? id;

    @JsonKey(name: 'fullName')
    final String fullName;

    final String email;
    final String? password;
    @JsonKey(includeIfNull: true)
    final String? profilePicture;
    final String? location;
    @JsonKey(name: 'groceryPoints')
    final int? grocerypoints;

    const UserApiModel({
      this.id,
      required this.fullName,
      required this.email,
      this.password,
      this.profilePicture,
      this.location,
      this.grocerypoints,
    });

    factory UserApiModel.fromJson(Map<String, dynamic> json) =>
        _$UserApiModelFromJson(json);

    Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

    // This toEntity() method is now correct because 'grocerypoints' will be populated.
    AuthEntity toEntity() {
      return AuthEntity(
        userId: id,
        fullName: fullName,
        email: email,
        password: password ?? '', // It's good practice to provide a default
        profilePicture: profilePicture,
        location: location,
        grocerypoints: grocerypoints,
      );
    }

    factory UserApiModel.fromEntity(AuthEntity entity) {
      return UserApiModel(
        id: entity.userId,
        fullName: entity.fullName,
        email: entity.email,
        password: entity.password,
        profilePicture: entity.profilePicture,
        location: entity.location,
        grocerypoints: entity.grocerypoints,
      );
    }

    @override
    List<Object?> get props => [
      id,
      fullName,
      password,
      email,
      profilePicture,
      location,
      grocerypoints,
    ];
  }