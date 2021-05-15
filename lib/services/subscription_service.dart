import 'package:leafety/models/message_error.dart';

import 'package:leafety/models/subscribe.dart';
import 'package:leafety/models/subscription_response.dart';
import 'package:leafety/models/subscriptions_dispensaries.dart';
import 'package:leafety/shared_preferences/auth_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:leafety/global/environment.dart';
import 'package:flutter/material.dart';

class SubscriptionService with ChangeNotifier {
  final prefs = new AuthUserPreferences();

  Future createSubscription(Subscription subscription) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/subscription/new');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(subscription),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final subscriptionResponse = subscriptionResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return subscriptionResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future unSubscription(Subscription subscription) async {
    // this.authenticated = true;

    final token = prefs.token;

    final urlFinal = ('${Environment.apiUrl}/api/subscription/unsubscribe');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(subscription),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final subscriptionResponse = subscriptionResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return subscriptionResponse;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future<DispensariesSubscriptorResponse> getSubscriptionsDispensaries(
      String clubId) async {
    final token = prefs.token;

    final urlFinal =
        ('${Environment.apiUrl}/api/subscription/subscriptions/profile/dispensaries/$clubId');

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final productsResponse =
          dispensariesSubscriptorResponseFromJson(resp.body);

      // roomModel.rooms = rooms;
      //roomModel.rooms;
      // this.rooms = rooms;

      //  print('$roomModel.rooms');

      return productsResponse;
    } catch (e) {
      return DispensariesSubscriptorResponse.withError('$e');
    }
  }
}
