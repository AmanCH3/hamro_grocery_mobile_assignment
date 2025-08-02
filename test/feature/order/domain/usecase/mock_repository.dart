// test/.../mock_repository.dart
import 'package:mocktail/mocktail.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/cart_repository.dart';

// Add this class to your mock file
class MockCartRepository extends Mock implements ICartRepository {}
