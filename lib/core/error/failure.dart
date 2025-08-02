import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  // The 'required String error' parameter has been removed from here.
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class LocalDataBaseFailure extends Failure {
  const LocalDataBaseFailure({required super.message});
}

class ApiFailure extends Failure {
  final int? statusCode;

  const ApiFailure({this.statusCode, required super.message});

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

class SharedPreferencesFailure extends Failure {
  const SharedPreferencesFailure({required super.message});
}
