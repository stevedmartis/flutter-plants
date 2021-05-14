import 'package:flutter_plants/models/plant.dart';
import 'package:flutter_plants/models/product_principal.dart';
import 'package:flutter_plants/models/product_response.dart';
import 'package:flutter_plants/models/products.dart';
import 'package:flutter_plants/models/products_response.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_plants/global/environment.dart';
import 'package:flutter/material.dart';

class ProductService with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  Product productModel;

  Product _product;

  int _countLikes = 0;

  ProductProfile _productProfile;
  Product get product => this._product;

  set product(Product valor) {
    this._product = valor;
    //notifyListeners();
  }

  int get countLikes => this._countLikes;

  set countLikes(int valor) {
    this._countLikes = valor;
    //notifyListeners();
  }

  ProductProfile get productProfile => this._productProfile;

  set productProfile(ProductProfile valor) {
    this._productProfile = valor;
    //notifyListeners();
  }

  Future<List<Product>> geProductByRoom(String roomId) async {
    final token = prefs.token;

    final urlFinal =
        ('${Environment.apiUrl}/api/product/products/room/$roomId');

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final productsResponse = productsResponseFromJson(resp.body);

      // roomModel.rooms = rooms;
      //roomModel.rooms;
      // this.rooms = rooms;

      //  print('$roomModel.rooms');

      return productsResponse.products;
    } catch (e) {
      return [];
    }
  }

  Future createProduct(Product product, List<Plant> plants) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/product/new');

    final data = {
      'name': product.name,
      'description': product.description,
      'catalogo': product.catalogo,
      'user': product.user,
      'coverImage': product.coverImage,
      'ratingInit': product.ratingInit,
      'cbd': product.cbd,
      'thc': product.thc,
      'plants': plants
    };
    final resp = await http.post(Uri.parse(urlFinal),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final productResponse = productResponseFromJson(resp.body);

      // this.rooms = roomResponse.rooms;

      return productResponse;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future editProduct(Product product, List<Plant> plants) async {
    // this.authenticated = true;

    final token = prefs.token;

    //final data = {'name': name, 'email': description, 'uid': uid};

    final data = {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'catalogo': product.catalogo,
      'user': product.user,
      'coverImage': product.coverImage,
      'ratingInit': product.ratingInit,
      'cbd': product.cbd,
      'thc': product.thc,
      'plants': plants
    };

    final urlFinal = ('${Environment.apiUrl}/api/product/update/product');

    final resp = await http.post(Uri.parse(urlFinal),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final productResponse = productResponseFromJson(resp.body);

      // this.rooms = roomResponse.rooms;

      return productResponse;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future deleteRoom(String roomId) async {
    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/room/delete/$roomId');

    try {
      await http.delete(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }
}
