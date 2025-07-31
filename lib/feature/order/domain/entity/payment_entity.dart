import 'package:equatable/equatable.dart';

class PaymentInitiationEntity extends Equatable {
  final String pidx; // Khalti Payment Identifier

  const PaymentInitiationEntity({required this.pidx});

  @override
  List<Object?> get props => [pidx];
}
