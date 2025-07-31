import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final bool isLoading;

  final bool isSuccess;

  // final String? imageName ;

  const RegisterState({
    required this.isLoading,
    required this.isSuccess,
    // this.imageName
  });

  const RegisterState.initial() : isLoading = false, isSuccess = false;

  RegisterState copyWith({bool? isLoading, bool? isSuccess}) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  
  List<Object?> get props => [isSuccess, isLoading];
}