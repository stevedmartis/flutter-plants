import 'package:flutter_plants/models/light.dart';
import 'package:flutter_plants/models/light_response.dart';
import 'package:flutter_plants/models/message_error.dart';

import 'package:flutter_plants/models/room.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_plants/global/environment.dart';
import 'package:flutter/material.dart';

class LightService with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  Light _light;
  Light get light => this._light;

  set light(Light valor) {
    this._light = valor;
    notifyListeners();
  }

  Future createLight(Light light) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/light/new');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(light),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final lightResponse = lightResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return lightResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editLight(Light light) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/light/update/light');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(light),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final lightResponse = lightResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return lightResponse;
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
}
