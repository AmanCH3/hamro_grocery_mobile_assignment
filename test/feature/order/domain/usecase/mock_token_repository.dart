// test/.../mock_repository.dart (or a new mock_prefs.dart)
import 'package:mocktail/mocktail.dart';
import 'package:hamro_grocery_mobile/app/shared_pref/token_shared_pref.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/repository/order_repository.dart';

class MockOrderRepository extends Mock implements IOrderRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}
