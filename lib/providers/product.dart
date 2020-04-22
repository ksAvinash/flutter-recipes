import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavourite() async {
    bool oldStatus = this.isFavourite;
    this.isFavourite = !oldStatus;
    notifyListeners();

    final url = 'https://flutterapp-74480.firebaseio.com/products/$id.json';

    try {
      print('patching isFavourite to ${this.isFavourite} at $url');
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavourite': this.isFavourite,
          },
        ),
      );
      if (response.statusCode >= 400) throw HttpException('error patching isFavourite');
      print('patching successful');
    } catch (err) {
      print('patching completed');
      print(err);
      this.isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
