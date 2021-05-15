import 'package:leafety/models/mensajes_response.dart';
import 'package:leafety/models/profiles.dart';
import 'package:flutter/material.dart';
import 'package:leafety/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;

import 'package:leafety/global/environment.dart';

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
