// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      profilePicture: json['profilePicture'] as String?,
      location: json['location'] as String?,
      grocerypoints: (json['groceryPoints'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      if (instance.id case final value?) '_id': value,
      'fullName': instance.fullName,
      'email': instance.email,
      'password': instance.password,
      'profilePicture': instance.profilePicture,
      'location': instance.location,
      'groceryPoints': instance.grocerypoints,
    };
