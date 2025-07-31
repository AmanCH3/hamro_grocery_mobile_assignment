import 'package:equatable/equatable.dart';

enum PaymentStatus {
  initial,
  loading,
  initiationSuccess,
  initiationFailure,
  verificationSuccess,
  verificationFailure,
}

class PaymentState extends Equatable {
  final PaymentStatus status;
  final String? pidx;
  final String? errorMessage;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.pidx,
    this.errorMessage,
  });

  factory PaymentState.initial() => const PaymentState();

  PaymentState copyWith({
    PaymentStatus? status,
    String? pidx,
    String? errorMessage,
  }) {
    return PaymentState(
      status: status ?? this.status,
      pidx: pidx ?? this.pidx,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pidx, errorMessage];
}
