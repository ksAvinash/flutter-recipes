import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    try {
      print('fetching orders');
      final url = 'https://flutterapp-74480.firebaseio.com/orders.json';
      final response = await http.get(url);
      final body = json.decode(response.body) as Map<String, dynamic>;
      print(body);
      if (body == null || body.length == 0) return;

      List<OrderItem> loadedOrders = [];
      body.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      });
      _orders = loadedOrders;
      print('total order found: ${_orders.length}');
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutterapp-74480.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    try {
      print('adding new order to server $url');
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((item) => {
                      'id': item.id,
                      'title': item.title,
                      'price': item.price,
                      'quantity': item.quantity,
                    })
                .toList(),
          },
        ),
      );
      print('order created successfully, $response');
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (err) {
      print('error creating order');
    }
  }
}
