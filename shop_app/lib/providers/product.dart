import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_esception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFevValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  void toggleFavoriteStatus(String? authToken, String? userId) async {
    if (authToken == null || userId == null) return;
    final url = Uri.parse(
      'https://flutter-project-15cc7-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken',
    );

    _setFevValue(!isFavorite);
    try {
      var response = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        _setFevValue(!isFavorite);
      }
    } catch (erorr) {
      _setFevValue(!isFavorite);
      throw HttpException('Could not make product as favorite.');
    }

    notifyListeners();
  }
}
