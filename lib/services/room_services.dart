import 'package:flutter_plants/models/message_error.dart';
import 'package:flutter_plants/models/room.dart';
import 'package:flutter_plants/models/room_response.dart';
import 'package:flutter_plants/models/rooms_response.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_plants/global/environment.dart';
import 'package:flutter/material.dart';

class RoomService with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  Room _room;

  Room get room => this._room;

  set room(Room valor) {
    this._room = valor;
    //notifyListeners();
  }

  Future<List<Room>> getRoomsUser(String userId) async {
    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/room/rooms/user/$userId');

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final roomsResponse = roomsResponseFromJson(resp.body);

      // roomModel.rooms = rooms;
      //roomModel.rooms;
      // this.rooms = rooms;

      //  print('$roomModel.rooms');

      return roomsResponse.rooms;
    } catch (e) {
      return [];
    }
  }

  Future createRoom(Room room) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/room/new');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(room),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final roomResponse = roomResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return roomResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editRoom(Room room) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/room/update/room');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(room),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final roomResponse = roomResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return roomResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
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

  Future updatePositionRoom(
      List<Room> rooms, int position, String userId) async {
    // this.authenticated = true;
    final urlFinal = ('${Environment.apiUrl}/api/room/update/position');

    final token = prefs.token;

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
