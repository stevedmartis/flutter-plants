import 'package:flutter_plants/global/environment.dart';
import 'package:flutter_plants/models/catalogo.dart';
import 'package:flutter_plants/models/catalogo_response.dart';
import 'package:flutter_plants/models/catalogos_products_response.dart';
import 'package:flutter_plants/models/catalogos_response.dart';
import 'package:flutter_plants/models/products_dispensary.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;

class CatalogosApiProvider {
  final prefs = new AuthUserPreferences();

  Future<CatalogosProductsResponse> getCatalogosProductsUser(
      String userId, String userAuthId) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/catalogo/catalogos/user/$userId/userAuth/$userAuthId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final catalogosResponse = catalogosProductsResponseFromJson(resp.body);
      return catalogosResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return CatalogosProductsResponse.withError("$error");
    }
  }

  Future<CatalogosResponse> getMyCatalogos(String userId) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/catalogo/catalogos/user/$userId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final catalogosResponse = catalogosResponseFromJson(resp.body);
      return catalogosResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return CatalogosResponse.withError("$error");
    }
  }

  Future<CatalogosProductsResponse> getMyCatalogosProducts(
      String userId) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/catalogo/catalogos/products/user/$userId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final catalogosResponse = catalogosProductsResponseFromJson(resp.body);

      return catalogosResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return CatalogosProductsResponse.withError("$error");
    }
  }

  Future<DispensaryProductsProfileResponse> getDispensaryProductsProfile(
      String clubId, String userId, String dispensaryId) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/product/dispensary/products/club/$clubId/user/$userId/dispensary/$dispensaryId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final dispensaryProductsResponse =
          dispensaryProductsResponseFromJson(resp.body);

      return dispensaryProductsResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return DispensaryProductsProfileResponse.withError("$error");
    }
  }

  Future<Catalogo> getCatalogo(String catalogoId) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/catalogo/catalogo/$catalogoId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final catalogoResponse = catalogoResponseFromJson(resp.body);
      return catalogoResponse.catalogo;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Catalogo(id: '0');
    }
  }
}
