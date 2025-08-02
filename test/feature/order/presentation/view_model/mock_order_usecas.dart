// test/feature/order/presentation/view_model/mock_order_usecases.dart
import 'package:mocktail/mocktail.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/create_order_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/get_my_order_usecase.dart'; // Assuming this is the correct name
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/get_my_payment_history_usecase.dart'; // Assuming this is the correct name
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/update_order_usecase.dart'; // Assuming this is the correct name

class MockCreateOrderUseCase extends Mock implements CreateOrderUseCase {}

class MockGetMyOrdersUseCase extends Mock implements GetMyOrdersUseCase {}

class MockUpdateOrderStatusUseCase extends Mock
    implements UpdateOrderStatusUseCase {}

class MockGetPaymentHistoryUseCase extends Mock
    implements GetPaymentHistoryUseCase {}
