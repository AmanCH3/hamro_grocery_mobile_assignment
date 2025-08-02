import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String
  password; // Note: Storing plain text password in an entity is generally not recommended for security.

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
  // This tells Equatable which properties to use for comparison.
  // If any of these properties change, the object will be considered different.
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
