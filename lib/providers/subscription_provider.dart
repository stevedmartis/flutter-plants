import 'dart:convert';

import 'package:leafety/global/environment.dart';

import 'package:leafety/models/message_error.dart';
import 'package:leafety/models/profilesDispensaries_response.dart';
import 'package:leafety/models/profiles_response.dart';
import 'package:leafety/models/subscribe.dart';
import 'package:leafety/models/subscription_response.dart';
import 'package:leafety/shared_preferences/auth_storage.dart';
import 'package:http/http.dart' as http;

class SubscriptionApiProvider {
  final prefs = new AuthUserPreferences();

  Future<Subscription> getSubscription(String userAuth, String userId) async {
    final urlFinal =
        ('${Environment.apiUrl}/api/subscription/subscription/$userAuth/$userId');

    final token = prefs.token;

    try {
      final resp = await http.get(Uri.parse(urlFinal),
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final subscriptionResponse = subscriptionResponseFromJson(resp.body);

      return subscriptionResponse.subscription;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Subscription(id: '0');
    }
  }

  Future disapproveSubscription(String subId) async {
    // this.authenticated = true;

    final token = prefs.token;

    final data = {'id': subId};

    final urlFinal = ('${Environment.apiUrl}/api/subscription/disapprove');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final subscriptionResponse = subscriptionResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return subscriptionResponse.ok;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future approveSubscription(String subId) async {
    // this.authenticated = true;

    final token = prefs.token;

    final data = {'id': subId};
    final urlFinal = ('${Environment.apiUrl}/api/subscription/approve');

    final resp = await http.post(Uri.parse(urlFinal),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      // final roomResponse = roomsResponseFromJson(resp.body);
      final subscriptionResponse = subscriptionResponseFromJson(resp.body);
      // this.rooms = roomResponse.rooms;

      return subscriptionResponse.ok;
    } else {
      final respBody = errorMessageResponseFromJson(resp.body);

      return respBody;
    }
  }

  Future<ProfilesDispensariesResponse> getProfilesSubscriptionsByUser(
      String userId) async {
    try {
      final urlFinal =
          ('${Environment.apiUrl}/api/notification/profiles/subscriptions/pending/$userId');

      final resp = await http.get(
        Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': prefs.token},
      );

      final profilesResponse = profilesDispensariesResponseFromJson(resp.body);

      return profilesResponse;
    } catch (error) {
      return ProfilesDispensariesResponse.withError("$error");
    }
  }

  Future<ProfilesDispensariesResponse> getProfilesSubsciptionsApprove(
      String subId) async {
    try {
      final urlFinal =
          ('${Environment.apiUrl}/api/notification/profiles/subscriptions/approve/user/$subId');

      final resp = await http.get(
        Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': prefs.token},
      );

      final profilesResponse = profilesDispensariesResponseFromJson(resp.body);

      return profilesResponse;
    } catch (error) {
      return ProfilesDispensariesResponse.withError("$error");
    }
  }

  Future<ProfilesResponse> getProfilesSubsciptionsApproveNotifi(
      String subId) async {
    try {
      final urlFinal =
          ('${Environment.apiUrl}/api/notification/profiles/subscriptions/notifi/user/$subId');

      final resp = await http.get(
        Uri.parse(urlFinal),
        headers: {'Content-Type': 'application/json', 'x-token': prefs.token},
      );

      final profilesResponse = profilesResponseFromJson(resp.body);

      return profilesResponse;
    } catch (error) {
      return ProfilesResponse.withError("$error");
    }
  }
}
