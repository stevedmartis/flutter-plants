import 'package:flutter_plants/models/dispensary.dart';
import 'package:flutter_plants/models/dispensary_products_response.dart';
import 'package:flutter_plants/models/dispensary_response.dart';
import 'package:flutter_plants/models/message_error.dart';
import 'package:flutter_plants/models/plant.dart';
import 'package:flutter_plants/models/plant_response.dart';
import 'package:flutter_plants/models/products.dart';

import 'package:flutter_plants/models/room.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_plants/global/environment.dart';
import 'package:flutter/material.dart';

class DispensaryService with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  Dispensary _dispensary;
  Dispensary get dispensary => this._dispensary;

  set dispensary(Dispensary valor) {
    this._dispensary = valor;
    // notifyListeners();
  }

  Future createDispensary(
      Dispensary dispensary, List<Product> productsDispensary) async {
    // this.authenticated = true;

    final data = {'dispensary': dispensary, 'products': productsDispensary};

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/dispensary/new');

    final resp = await http.post(Uri.parse(urlFinal),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final dispensaryResponse = dispensaryResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return dispensaryResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future deliveredDispensary(String dispensaryId) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal =
        ('${Environment.apiUrl}/api/dispensary/update-delivered-dispensary/$dispensaryId');

    final resp = await http.get(Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final dispensaryResponse = dispensaryResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return dispensaryResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future updateDispensary(
      Dispensary dispensary, List<Product> productsDispensary) async {
    // this.authenticated = true;

    final data = {'dispensary': dispensary, 'products': productsDispensary};

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/dispensary/update-dispensary');

    final resp = await http.post(Uri.parse(urlFinal),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final dispensaryResponse = dispensaryResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return dispensaryResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editPlant(Plant plant) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/plant/update/plant');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(plant),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final plantResponse = plantResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return plantResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future deletePlant(String plantId) async {
    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/room/delete/$plantId');

    try {
      await http.delete(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future updatePositionRoom(
      List<Room> rooms, int position, String userId) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/room/update/position');

    //final data = {'name': name, 'email': description, 'uid': uid};
    final data = {'rooms': rooms, 'userId': userId};

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

  Future<DispensaryproductsResponse> getDispensaryActiveProducts(
      String userId) async {
    try {
      final token = prefs.token;

      final urlFinal =
          ('${Environment.apiUrl}/api/dispensary/active/products/user/$userId');

      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final plantsResponse = dispensaryProductsResponseFromJson(resp.body);

      return plantsResponse;
    } catch (e) {
      return DispensaryproductsResponse.withError("$e");
    }
  }
}
