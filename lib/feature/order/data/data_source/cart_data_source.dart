import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';

abstract class ICartDataSource {
  Future<List<OrderItem>> getCartItems();
  Future<void> addItem(OrderItem item);
  Future<void> removeItem(String id);
  Future<void> updateItemQuantity(String id, int newQuantity);
  Future<void> clearCart();
}
