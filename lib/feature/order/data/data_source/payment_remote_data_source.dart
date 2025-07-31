import 'package:dio/dio.dart';
import 'package:hamro_grocery_mobile/app/constant/api_endpoints.dart';
import 'package:hamro_grocery_mobile/core/network/api_service.dart';
import 'package:hamro_grocery_mobile/feature/order/data/data_source/payment_datasource.dart';
import 'package:hamro_grocery_mobile/feature/order/data/model/order_item_api.dart';
import 'package:hamro_grocery_mobile/feature/order/data/model/payment_api_model.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';

class PaymentRemoteDataSourceImpl implements IPaymentDataSource {
  final ApiService _apiService;
  PaymentRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<PaymentInitiationApiModel> initiateKhaltiPayment({
    required List<OrderItem> items,
    required String address,
    required String phone,
    required bool applyDiscount,
    String? token,
  }) async {
    try {
      final itemJsonList =
          items
              .map((item) => OrderItemApiModel.fromEntity(item).toJson())
              .toList();
      final response = await _apiService.dio.post(
        ApiEndpoints.khaltiInitiate,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'items': itemJsonList,
          'address': address,
          'phone': phone,
          'applyDiscount': applyDiscount,
        },
      );

      if (response.statusCode == 200) {
        return PaymentInitiationApiModel.fromJson(response.data);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to initiate payment',
        );
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }

  @override
  Future<void> verifyKhaltiPayment({
    required String pidx,
    String? token,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.khaltiVerify,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {'pidx': pidx},
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Failed to verify payment');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
}
