import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './../models/http_exception.dart';

import './product.dart';

class AllProducts with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouritedItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Product getProductDetailsById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> addNewProduct(Product product) async {
    try {
      final url = 'https://flutterapp-74480.firebaseio.com/products.json';

      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavourite': product.isFavourite,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavourite: product.isFavourite,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final index = _items.indexWhere((prod) => prod.id == updatedProduct.id);
    if (index < 0) return;
    try {
      final url =
          'https://flutterapp-74480.firebaseio.com/products/${updatedProduct.id}.json';
      print('patching product $url');
      await http.patch(
        url,
        body: json.encode({
          'title': updatedProduct.title,
          'description': updatedProduct.description,
          'imageUrl': updatedProduct.imageUrl,
          'price': updatedProduct.price,
          'isFavourite': updatedProduct.isFavourite,
        }),
      );
      _items[index] = updatedProduct;
      notifyListeners();
    } catch (err) {
      print('error patching product update');
      print(err);
    }
  }

  Future<void> deleteProductbyId(String productId) async {
    final index = _items.indexWhere((prod) => prod.id == productId);
    if (index < 0) return;

    var deletingProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();

    // try {
    final url =
        'https://flutterapp-74480.firebaseio.com/products/$productId.json';
    print('deleting product $url');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(index, deletingProduct);
      notifyListeners();
      throw HttpException('failed to  delete product: $productId');
    } else
      print('delete $productId successful');
    // } catch (err) {
    //   print(err);
    //   _items.insert(index, deletingProduct);
    //   notifyListeners();
    // }
  }

  Future<void> fetchProductsFromServer() async {
    try {
      final url = 'https://flutterapp-74480.firebaseio.com/products.json';
      print('fetching server products..');
      final response = await http.get(url);
      final body = json.decode(response.body) as Map<String, dynamic>;
      print('server data: $body');
      body.forEach((prodId, prodData) {
        if (_items.indexWhere((prods) => prods.id == prodId) == -1) {
          final temp = Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavourite: prodData['isFavourite'],
          );
          _items.add(temp);
        }
      });
      notifyListeners();
    } catch (err) {
      print('error fetching products from server');
    }
  }
}
