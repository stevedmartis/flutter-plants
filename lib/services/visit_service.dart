import 'package:leafety/models/message_error.dart';

import 'package:leafety/models/visit.dart';
import 'package:leafety/models/visit_response.dart';
import 'package:leafety/models/visits_response.dart';
import 'package:leafety/shared_preferences/auth_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:leafety/global/environment.dart';
import 'package:flutter/material.dart';

class VisitService with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  Visit _visit;
  Visit get visit => this._visit;

  set visit(Visit valor) {
    this._visit = valor;
    notifyListeners();
  }

  Future createVisit(Visit visit) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/visit/new');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(visit),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final visitResponse = visitResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return visitResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future editVisit(Visit visit) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/visit/update/visit');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(visit),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final visitResponse = visitResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;
      return visitResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future deleteVisit(String visitId) async {
    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/visit/delete/$visitId');

    try {
      await http.delete(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Visit>> getLastVisitsByUser(String userId) async {
    final urlFinal = ('${Environment.apiUrl}/api/visit/visits/user/$userId');

    try {
      final token = prefs.token;

      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final visitsResponse = visitsResponseFromJson(resp.body);

      return visitsResponse.visits;
    } catch (e) {
      return [];
    }
  }
}
