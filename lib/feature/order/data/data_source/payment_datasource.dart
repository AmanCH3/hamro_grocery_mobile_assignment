import 'package:hamro_grocery_mobile/feature/order/data/model/payment_api_model.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';

abstract class IPaymentDataSource {
  Future<PaymentInitiationApiModel> initiateKhaltiPayment({
    required List<OrderItem> items,
    required String address,
    required String phone,
    required bool applyDiscount,
    String? token,
  });

  Future<void> verifyKhaltiPayment({required String pidx, String? token});
}
