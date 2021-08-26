import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_esception.dart';
import 'package:shop_app/screens/product_details_Screen.dart';
import 'dart:convert';

import '../dummy_products.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items;
  final String? _authToken;
  final String? _userId;

  Products({String? authToken, String? userId, List<Product>? items})
      : this._authToken = authToken,
        this._userId = userId,
        this._items = items ?? [];

  List<Product> get items {
    return List.from(_items);
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';

    var url = Uri.parse(
      'https://flutter-project-15cc7-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterString',
    );

    try {
      final response = await http.get(url);
      final extractedDate = json.decode(response.body);

      if (extractedDate == null) return;

      url = Uri.parse(
        'https://flutter-project-15cc7-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken',
      );
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];

      extractedDate.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: favoriteData?[prodId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
      'https://flutter-project-15cc7-default-rtdb.firebaseio.com/products.json?auth=$_authToken',
    );
    final response = await http.post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'creatorId': _userId,
      }),
    );

    final newProduct = Product(
      id: json.decode(response.body)['name'],
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    _items.insert(0, newProduct);

    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
        'https://flutter-project-15cc7-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken',
      );
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
      'https://flutter-project-15cc7-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken',
    );
    var existingProductIndex = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
    var response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
  }
}
