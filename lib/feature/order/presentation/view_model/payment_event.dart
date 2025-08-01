import 'package:equatable/equatable.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
// Remove the unnecessary import
// import 'package:khalti_flutter/khalti_flutter.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object> get props => [];
}

class KhaltiPaymentStarted extends PaymentEvent {
  // ... this class is correct, no changes needed
  final List<OrderItem> items;
  final String address;
  final String phone;
  final bool applyDiscount;

  const KhaltiPaymentStarted({
    required this.items,
    required this.address,
    required this.phone,
    required this.applyDiscount,
  });

  @override
  List<Object> get props => [items, address, phone, applyDiscount];
}

class KhaltiPaymentVerified extends PaymentEvent {
  final String pidx;

  const KhaltiPaymentVerified({required this.pidx}); // <-- FIX CONSTRUCTOR

  @override
  List<Object> get props => [pidx]; // <-- FIX PROPS
}
