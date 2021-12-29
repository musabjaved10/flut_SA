import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  var _showFavorites = false;

  Products(this.authToken, this._items);
  final String? authToken;

  List<Product> get items {
    // if(_showFavorites){
    //   return _items.where((element) => element.isFavourite ).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  // void showFavoritesOnly(){
  //   _showFavorites = true;
  //   notifyListeners();
  // }

  // void showAll(){
  //   _showFavorites = false;
  //   notifyListeners();
  // }


  Product findById({required String id}) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        "https://flutter-db-f5cbb-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken");
    try {
      final response = await http.get(url);
      if(response.body == 'null'){
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFavourite: prodData['isFavourite']
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print('ooops');
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://flutter-db-f5cbb-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken");
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavourite': product.isFavourite,
          }));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }

    //returning inside function of a function will not return to the main function
    // Future.value()
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    try {
      final url = Uri.parse(
          "https://flutter-db-f5cbb-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken");
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'description': newProduct.description
          }));

      final productIndex = _items.indexWhere((p) => p.id == id);
      if (productIndex >= 0) {
        _items[productIndex] = newProduct;
        notifyListeners();
      } else {
        print('...');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final url = Uri.parse(
          "https://flutter-db-f5cbb-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken");
      final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
      Product? existingProduct = _items[existingProductIndex];
      _items.removeAt(existingProductIndex);
      notifyListeners();

      //I'm interested only if there's an error
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException('Could not delete product');
      }
      // throw is like a return and the code would not reach here if above if-block executes
      existingProduct = null;
    } catch (e) {
      rethrow;
    }
  }
}
