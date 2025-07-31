import 'package:dio/dio.dart';
import 'package:hamro_grocery_mobile/app/constant/api_endpoints.dart';
import 'package:hamro_grocery_mobile/core/network/api_service.dart';
import 'package:hamro_grocery_mobile/feature/order/data/data_source/order_item_data_source.dart';
import 'package:hamro_grocery_mobile/feature/order/data/model/order_item_api.dart';
import 'package:hamro_grocery_mobile/feature/order/data/model/order_model_api.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_entity.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';

class OrderRemoteDataSourceImpl implements IOrderDataSource {
  final ApiService _apiService;

  OrderRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<OrderApiModel> createOrder({
    required List<OrderItem> items,
    required String address,
    required String phone,
    required bool applyDiscount,
    String? token,
  }) async {
    try {
      final List<Map<String, dynamic>> itemJsonList =
          items
              .map(
                (itemEntity) =>
                    OrderItemApiModel.fromEntity(itemEntity).toJson(),
              )
              .toList();

      final response = await _apiService.dio.post(
        ApiEndpoints.orders,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'items': itemJsonList,
          'address': address,
          'phone': phone,
          'applyDiscount': applyDiscount,
        },
      );

      if (response.statusCode == 201) {
        return OrderApiModel.fromJson(response.data['order']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create order');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      final response = await _apiService.dio.put(
        '${ApiEndpoints.orders}/$orderId',
        data: {'status': status.name},
      );

      if (response.statusCode == 200) {
        final apiModel = OrderApiModel.fromJson(response.data['order']);
        return apiModel.toEntity();
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to update order status',
        );
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<OrderEntity>> getMyOrders(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.myOrders,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print('Order respnse $response');
      if (response.statusCode == 200) {
        final List<dynamic> orderList = response.data['orders'];
        final List<OrderApiModel> apiModels =
            orderList.map((json) => OrderApiModel.fromJson(json)).toList();
        return OrderApiModel.toEntityList(apiModels);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to load your orders',
        );
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    try {
      final response = await _apiService.dio.get(
        '${ApiEndpoints.orders}/$orderId',
      );
      if (response.statusCode == 200) {
        final apiModel = OrderApiModel.fromJson(response.data['order']);
        return apiModel.toEntity();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to find order');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<OrderEntity>> getPaymentHistory() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.paymentHistory);
      if (response.statusCode == 200) {
        final List<dynamic> historyList = response.data['history'];
        final List<OrderApiModel> apiModels =
            historyList.map((json) => OrderApiModel.fromJson(json)).toList();
        return OrderApiModel.toEntityList(apiModels);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to load payment history',
        );
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
