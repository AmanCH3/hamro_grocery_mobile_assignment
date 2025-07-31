import 'dart:convert';

import 'package:hamro_grocery_mobile/feature/order/data/data_source/cart_data_source.dart';
import 'package:hamro_grocery_mobile/feature/order/data/model/order_item_api.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/entity/order_item_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartLocalDataSourceImpl implements ICartDataSource {
  final SharedPreferences _prefs;
  static const _cartKey = 'shopping_cart_items';

  CartLocalDataSourceImpl({required SharedPreferences sharedPreferences})
    : _prefs = sharedPreferences;

  // Private helper to save the list of items to local storage
  Future<void> _saveCartToPrefs(List<OrderItemApiModel> items) async {
    final List<Map<String, dynamic>> jsonList =
        items.map((item) => item.toJson()).toList();
    await _prefs.setString(_cartKey, json.encode(jsonList));
  }

  @override
  Future<List<OrderItem>> getCartItems() async {
    final jsonString = _prefs.getString(_cartKey);
    if (jsonString == null) {
      return [];
    }
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((json) => OrderItemApiModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<void> addItem(OrderItem item) async {
    final items = await getCartItems();
    final apiModels =
        items.map((e) => OrderItemApiModel.fromEntity(e)).toList();

    // Check if item already exists
    final index = apiModels.indexWhere((i) => i.productId == item.productId);

    if (index != -1) {
      final existingItem = apiModels[index];
      apiModels[index] = OrderItemApiModel.fromEntity(
        existingItem.toEntity().copyWith(
          quantity: existingItem.quantity! + item.quantity,
        ),
      );
    } else {
      apiModels.add(OrderItemApiModel.fromEntity(item));
    }
    await _saveCartToPrefs(apiModels);
  }

  @override
  Future<void> updateItemQuantity(String id, int newQuantity) async {
    final items = await getCartItems();
    final apiModels =
        items.map((e) => OrderItemApiModel.fromEntity(e)).toList();
    final index = apiModels.indexWhere((i) => i.productId == id);

    if (index != -1) {
      if (newQuantity > 0) {
        apiModels[index] = OrderItemApiModel.fromEntity(
          apiModels[index].toEntity().copyWith(quantity: newQuantity),
        );
      }
    } else {
      apiModels.removeAt(index);
    }
    await _saveCartToPrefs(apiModels);
  }

  @override
  Future<void> clearCart() async {
    await _prefs.remove(_cartKey);
  }

  @override
  Future<void> removeItem(String id) async {
    final items = await getCartItems();
    final apiModels =
        items.map((e) => OrderItemApiModel.fromEntity(e)).toList();
    apiModels.removeWhere((item) => item.productId == id);
    await _saveCartToPrefs(apiModels);
  }
}
