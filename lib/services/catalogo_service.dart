import 'package:flutter_plants/models/catalogo.dart';
import 'package:flutter_plants/models/catalogo_response.dart';
import 'package:flutter_plants/models/message_error.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_plants/global/environment.dart';
import 'package:flutter/material.dart';

class CatalogoService with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  Catalogo _catalogo;
  Catalogo get catalogo => this._catalogo;

  set catalogo(Catalogo valor) {
    this._catalogo = valor;
    // notifyListeners();
  }

  Future createCatalogo(Catalogo catalogo) async {
    // this.authenticated = true;

    final urlFinal = ('${Environment.apiUrl}/api/catalogo/new');
    final token = prefs.token;

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(catalogo),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final catalogoResponse = catalogoResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return catalogoResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editCatalogo(Catalogo plant) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/catalogo/update/catalogo');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(plant),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final catalogoResponse = catalogoResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return catalogoResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future deleteCatalogo(String catalogoId) async {
    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/catalogo/delete/$catalogoId');

    try {
      await http.delete(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future updatePositionCatalogo(
      List<Catalogo> catalogos, int position, String userId) async {
    // this.authenticated = true;

    final urlFinal = ('${Environment.apiUrl}/api/catalogo/update/position');

    final token = prefs.token;

    //final data = {'name': name, 'email': description, 'uid': uid};
    final data = {'catalogos': catalogos, 'userId': userId};

    final resp = await http.post(Uri.parse(urlFinal),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);

      // this.rooms = roomResponse.rooms;

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }
}
