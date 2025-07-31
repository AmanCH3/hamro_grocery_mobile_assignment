import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/payment_entity.dart';

class PaymentInitiationApiModel extends Equatable {
  final String pidx;

  const PaymentInitiationApiModel({required this.pidx});

  factory PaymentInitiationApiModel.fromJson(Map<String, dynamic> json) {
    return PaymentInitiationApiModel(pidx: json['pidx'] as String);
  }

  PaymentInitiationEntity toEntity() => PaymentInitiationEntity(pidx: pidx);

  @override
  List<Object?> get props => [pidx];
}
