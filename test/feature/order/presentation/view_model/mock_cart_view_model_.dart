// test/feature/order/presentation/view_model/mock_cart_usecases.dart
import 'package:mocktail/mocktail.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/add_cart_item_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/clear_cart_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/get_cart_item_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/remote_cart_item_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/update_cart_item_usecase.dart';

// Use correct use case names from the BLoC
class MockGetCartItemsUseCase extends Mock implements GetCartItemsUseCase {}

class MockAddItemToCartUseCase extends Mock implements AddItemToCartUseCase {}

class MockUpdateCartItemQuantityUseCase extends Mock
    implements UpdateCartItemQuantityUseCase {}

class MockRemoveItemFromCartUseCase extends Mock
    implements RemoveItemFromCartUseCase {}

class MockClearCartUseCase extends Mock implements ClearCartUseCase {}
