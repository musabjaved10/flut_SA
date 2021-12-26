import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false}
      );

  void _setFavValue(bool oldValue){
    isFavourite = oldValue;
    notifyListeners();
  }
  Future<void> toggleIsFavorite() async{
    final oldStatus = isFavourite;
    final url = Uri.parse(
        "https://flutter-db-f5cbb-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json");
    isFavourite = !isFavourite;

    try {
      notifyListeners();
      await http.patch(url, body: json.encode({
        'isFavourite': isFavourite
      })).then((response) {
        if(response.statusCode >= 400){
          _setFavValue(oldStatus);
        }
      });
    }catch(e){
      isFavourite=oldStatus;
      notifyListeners();
    }
  }
}
