import 'package:flutter_plants/models/air.dart';
import 'package:flutter_plants/models/air_response.dart';
import 'package:flutter_plants/models/message_error.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_plants/global/environment.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class AirService with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  Air _air;
  Air get air => this._air;

  set air(Air valor) {
    this._air = valor;
    notifyListeners();
  }

  Future createAir(Air air) async {
    // this.authenticated = true;

    final urlFinal = ('${Environment.apiUrl}/api/air/new');

    final token = prefs.token;

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(air),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final airResponse = airResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return airResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editAir(Air plant) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/air/update/air');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(plant),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final airResponse = airResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return airResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }
}
