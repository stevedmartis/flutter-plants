import 'dart:convert';

import 'package:flutter_plants/global/environment.dart';
import 'package:flutter_plants/models/dispensaries_products_response%20copy.dart';
import 'package:flutter_plants/models/favorite_response.dart';
import 'package:flutter_plants/models/product_response.dart';
import 'package:flutter_plants/models/products.dart';
import 'package:flutter_plants/models/products_dispensary.dart';
import 'package:flutter_plants/models/products_profiles_response.dart';
import 'package:flutter_plants/models/products_response.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;

class ProductsApiProvider {
  final prefs = new AuthUserPreferences();

  Future<ProductsProfilesResponse> getProductsProfiles(String uid) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/product/principal/products/$uid');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final productsResponse = productsProfilesResponseFromJson(resp.body);
      return productsResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ProductsProfilesResponse.withError("$error");
    }
  }

  Future<List<Product>> getProductCatalogo(String catalogoId) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/product/products/catalogo/$catalogoId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantsResponse = productsResponseFromJson(resp.body);
      return plantsResponse.products;
    } catch (e) {
      return [];
    }
  }

  Future<Product> getProduct(String productId) async {
    final urlFinal = ('${Environment.apiUrl}/api/product/product/$productId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantResponse = productResponseFromJson(resp.body);
      return plantResponse.product;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Product(id: '0');
    }
  }

  Future<DispensaryProductsProfileResponse> getProductsDispensary(
      String productId) async {
    final urlFinal = ('${Environment.apiUrl}/api/product/product/$productId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantResponse = dispensaryProductsResponseFromJson(resp.body);
      return plantResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return DispensaryProductsProfileResponse.withError('$error');
    }
  }

  Future deleteProduct(String productId) async {
    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/product/delete/$productId');

    try {
      await http.delete(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<FavoriteResponse> addUpdateFavorite(
      String productId, String userId) async {
    // this.authenticated = true;

    final data = {'product': productId, 'user': userId};

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/favorite/update/');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final favoriteResponse = favoriteResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return favoriteResponse;
    } else {
      return FavoriteResponse.withError("");
    }
  }

  Future<DispensariesProductsResponse> dispensariesProducts(
      String clubId, subId) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/dispensary/dispensaries/products/club/$clubId/user/$subId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final catalogosResponse = storeFromJson(resp.body);
      return catalogosResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return DispensariesProductsResponse.withError("$error");
    }
  }
}
