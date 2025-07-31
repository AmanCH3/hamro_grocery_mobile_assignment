import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: 1)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;


  UserHiveModel({
    String? userId,
    required this.fullName,
    required this.email,
    required this.password,
  
  }) : userId = userId ?? const Uuid().v4();

  AuthEntity toEntity() => AuthEntity(
    userId: userId,
    fullName: fullName,
    email: email,
    password: password,
  );

  factory UserHiveModel.fromEntity(AuthEntity entity) => UserHiveModel(
    userId: entity.userId,
    fullName: entity.fullName,
    email: entity.email,
    password: entity.password,
  
  );
}