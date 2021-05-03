// To parse this JSON data, do
//
//     final store = storeFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/profiles.dart';
import 'package:chat/models/subscribe.dart';

DispensariesSubscriptorResponse dispensariesSubscriptorResponseFromJson(
        String str) =>
    DispensariesSubscriptorResponse.fromJson(json.decode(str));

String storeToJson(DispensariesSubscriptorResponse data) =>
    json.encode(data.toJson());

class DispensariesSubscriptorResponse {
  DispensariesSubscriptorResponse({
    this.ok,
    this.dispensariesSubscriptors,
  });

  bool ok;
  List<DispensariesSubscriptor> dispensariesSubscriptors;

  factory DispensariesSubscriptorResponse.fromJson(Map<String, dynamic> json) =>
      DispensariesSubscriptorResponse(
        ok: json["ok"],
        dispensariesSubscriptors: List<DispensariesSubscriptor>.from(
            json["dispensariesSubscriptors"]
                .map((x) => DispensariesSubscriptor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "dispensariesSubscriptors":
            List<dynamic>.from(dispensariesSubscriptors.map((x) => x.toJson())),
      };

  DispensariesSubscriptorResponse.withError(String errorValue);
}

class DispensariesSubscriptor {
  DispensariesSubscriptor(
      {this.gramsRecipe,
      this.club,
      this.dateDelivery,
      this.isActive,
      this.isDelivered,
      this.isCancel,
      this.isUpdate,
      this.isUserNotifi,
      this.isClubNotifi,
      this.isEdit,
      this.subscriptor,
      this.subscription,
      this.createdAt,
      this.updatedAt,
      this.gramsTotal});

  int gramsRecipe;
  Club club;
  String dateDelivery;
  bool isActive;
  bool isDelivered;
  bool isCancel;
  bool isUpdate;
  bool isUserNotifi;
  bool isClubNotifi;
  bool isEdit;
  DateTime createdAt;
  DateTime updatedAt;
  Profiles subscriptor;
  Subscription subscription;
  int gramsTotal;

  factory DispensariesSubscriptor.fromJson(Map<String, dynamic> json) =>
      DispensariesSubscriptor(
        gramsRecipe: json["gramsRecipe"],
        club: clubValues.map[json["club"]],
        dateDelivery: json["dateDelivery"],
        isActive: json["isActive"],
        isDelivered: json["isDelivered"],
        isCancel: json["isCancel"],
        isUpdate: json["isUpdate"],
        isUserNotifi: json["isUserNotifi"],
        isClubNotifi: json["isClubNotifi"],
        isEdit: json["isEdit"],
        gramsTotal: json["gramsTotal"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        subscriptor: Profiles.fromJson(json["subscriptor"]),
        subscription: Subscription.fromJson(json["subscription"]),
      );

  Map<String, dynamic> toJson() => {
        "gramsRecipe": gramsRecipe,
        "club": clubValues.reverse[club],
        "dateDelivery": dateDelivery,
        "isActive": isActive,
        "isDelivered": isDelivered,
        "isCancel": isCancel,
        "isUpdate": isUpdate,
        "isUserNotifi": isUserNotifi,
        "isClubNotifi": isClubNotifi,
        "isEdit": isEdit,
        "gramsTotal": gramsTotal,
        "subscriptor": subscriptor.toJson(),
        "subscription": subscription.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

enum Club {
  THE_602_C42092_C35_D35160_D67_DC3,
  THE_60516_C99_ECE0670857_A81260,
  THE_604_EDD9_C6_C94527_DBD670_B32
}

final clubValues = EnumValues({
  "602c42092c35d35160d67dc3": Club.THE_602_C42092_C35_D35160_D67_DC3,
  "604edd9c6c94527dbd670b32": Club.THE_604_EDD9_C6_C94527_DBD670_B32,
  "60516c99ece0670857a81260": Club.THE_60516_C99_ECE0670857_A81260
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
