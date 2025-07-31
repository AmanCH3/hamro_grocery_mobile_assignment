import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String password;

  final String? profilePicture;
  final String? location;
  final int? grocerypoints;

  const AuthEntity({
    this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    this.profilePicture,
    this.location,
    this.grocerypoints,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    userId,
    fullName,
    email,
    password,
    profilePicture,
    location,
    grocerypoints,
  ];
}
