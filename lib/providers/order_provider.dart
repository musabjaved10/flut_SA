import 'package:flutter/material.dart';

import 'cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({required this.id,
    required this.amount,
    required this.products,
    required this.dateTime});
}

class Orders with ChangeNotifier {
  final String? authToken;
  Orders(this.authToken, this._orders);

  List<OrderItem> _orders = [];


  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        "https://flutter-db-f5cbb-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken");
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) =>
          {
            'id': cp.id,
            'title': cp.title,
            'quantity': cp.quantity,
            'price': cp.price
          })
              .toList()
        }));

    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timestamp));
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        "https://flutter-db-f5cbb-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken");
    final response = await http.get(url);
    if(response.body == 'null'){
      return;
    }
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>).map((item) =>
            CartItem(
              id: item['id'],
              price: item['price'],
              title: item['title'],
              quantity: item['quantity'],
            )).toList(),
      ));
    });
    _orders = loadedOrders;
    notifyListeners();
  }
}
