import 'package:flutter_plants/models/mensajes_response.dart';
import 'package:flutter_plants/models/profiles.dart';
import 'package:flutter_plants/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plants/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_plants/global/environment.dart';

class ChatService with ChangeNotifier {
  Profiles userFor;
  final prefs = new AuthUserPreferences();

  Future<List<Message>> getChat(String userID) async {
    final urlFinal = ('${Environment.apiUrl}/api/messages/$userID');

    final resp = await http.get(Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': prefs.token});

    final messageResponse = messageResponseFromJson(resp.body);

    return messageResponse.messages;
  }
}
