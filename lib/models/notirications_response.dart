// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:leafety/models/dispensary.dart';
import 'package:leafety/models/mensajes_response.dart';
import 'package:leafety/models/subscribe.dart';

NotificationsResponse notificationsResponseFromJson(String str) =>
    NotificationsResponse.fromJson(json.decode(str));

String notificationsResponseToJson(NotificationsResponse data) =>
    json.encode(data.toJson());

class NotificationsResponse {
  NotificationsResponse(
      {this.ok,
      this.subscriptionsNotifi,
      this.messagesNotifi,
      this.dispensaryNotifi});

  bool ok;
  List<Subscription> subscriptionsNotifi;
  List<Message> messagesNotifi;
  List<Dispensary> dispensaryNotifi;

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      NotificationsResponse(
          ok: json["ok"],
          subscriptionsNotifi: List<Subscription>.from(
              json["subscriptionsNotifi"].map((x) => Subscription.fromJson(x))),
          messagesNotifi: List<Message>.from(
              json["messagesNotifi"].map((x) => Message.fromJson(x))),
          dispensaryNotifi: List<Dispensary>.from(
              json["dispensaryNotifi"].map((x) => Dispensary.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "subscriptionsNotifi":
            List<dynamic>.from(subscriptionsNotifi.map((x) => x.toJson())),
        "messagesNotifi":
            List<dynamic>.from(messagesNotifi.map((x) => x.toJson())),
        "dispensaryNotifi":
            List<dynamic>.from(dispensaryNotifi.map((x) => x.toJson())),
      };

  NotificationsResponse.withError(String errorValue);
}
