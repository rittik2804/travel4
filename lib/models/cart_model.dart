import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart {
  final String userId;
  final List<CartItem> items;

  Cart({
    required this.userId,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'items': items.map((item) => item.toJson()).toList(),
      };

  double get totalPrice =>
      items.fold(0, (total, item) => total + item.price * item.quantity);

  int get totalItemsQuantity =>
      items.fold(0, (total, item) => total + item.quantity);

  int get totalItems => items.length;

  void removeItem(CartItem item) {
    items.remove(item);
  }

  void addItem(CartItem newItem) {
    final existingItem = items.firstWhereOrNull(
      (item) => item.dutyId == newItem.dutyId,
    );
    if (existingItem != null) {
      existingItem.quantity += newItem.quantity;
    } else {
      items.add(newItem);
    }
  }
}

class CartItem {
  final String dutyId;
  final String name;
  final String photo;
  final String type;
  int quantity;
  double price;

  CartItem({
    required this.dutyId,
    this.quantity = 1,
    this.price = 0,
    this.name = "",
    this.photo = "",
    this.type = "",
  });

  Map<String, dynamic> toJson() => {
        'duty_id': dutyId,
        'name': name,
        'photo': photo,
        'price': price,
        'quantity': quantity,
      };
}





class CartStorage {
  static const String cartKey = 'cart';

  static Future<void> addToCart(CartItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final cartList = prefs.getStringList(cartKey) ?? [];
    cartList.add(jsonEncode(item.toJson())); // Encode the CartItem to JSON and add it to the list
    await prefs.setStringList(cartKey, cartList);
    print(prefs.getKeys());
    print(prefs.getStringList(cartKey));
  }

  static Future<List<CartItem>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartList = prefs.getStringList(cartKey) ?? [];
    print(cartList);
    return cartList.map((itemJson) {
      final Map<String, dynamic> itemData = jsonDecode(itemJson);
      return CartItem(
        dutyId: itemData['id'] ?? "",
        type: itemData['type'] ?? "",
        name: itemData['name']?? "",
        photo: itemData['photo']?? "",
        price: itemData['price']?? "",
        quantity: itemData['quantity']?? "",
      );
    }).toList();
  }
}


