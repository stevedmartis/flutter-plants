import 'package:leafety/models/notirications_response.dart';
import 'package:leafety/models/profiles.dart';
import 'package:flutter/material.dart';
import 'package:leafety/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;

import 'package:leafety/global/environment.dart';

class NotificationService with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  Profiles userFor;

  Future<NotificationsResponse> getNotificationByUser(String userID) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/notification/notifications/user/$userID');

    final resp = await http.get(Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': prefs.token});

    final messageResponse = notificationsResponseFromJson(resp.body);

    return messageResponse;
  }
}
