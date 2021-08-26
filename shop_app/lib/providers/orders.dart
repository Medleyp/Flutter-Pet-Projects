import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders;
  final String? _authToken;
  final String? _userId;

  Orders({String? authToken, List<OrderItem>? orders, String? userId})
      : this._authToken = authToken,
        this._userId = userId,
        this._orders = orders ?? [];

  List<OrderItem> get orders {
    return List.from(_orders);
  }

  Future<void> fatchAndSetOrders() async {
    final url = Uri.parse(
      'https://flutter-project-15cc7-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken',
    );
    var respone = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(respone.body);
    extractedData?.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
    _orders = List.from(loadedOrders.reversed);
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
      'https://flutter-project-15cc7-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken',
    );
    final timeStamp = DateTime.now();
    var response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'products': cartProducts.map((cp) {
          return {
            'id': cp.id,
            'title': cp.title,
            'price': cp.price,
            'quantity': cp.quantity,
          };
        }).toList(),
        'dateTime': timeStamp.toIso8601String(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
