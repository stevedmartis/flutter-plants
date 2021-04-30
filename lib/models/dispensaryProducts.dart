import 'dart:convert';

import 'package:chat/models/product_dispensary.dart';

DispensaryProducts dispensaryFromJson(String str) =>
    DispensaryProducts.fromJson(json.decode(str));

String subscribeToJson(DispensaryProducts data) => json.encode(data.toJson());

class DispensaryProducts {
  DispensaryProducts(
      {this.id = "",
      this.subscriptor = "",
      this.club = "",
      this.createdAt,
      this.updatedAt,
      this.gramsRecipe = 0,
      this.isUpdate = false,
      this.isActive = false,
      this.isDelivered = false,
      this.isCancel = false,
      this.isClubNotifi = false,
      this.isUserNotifi = false,
      this.dateDelivery = '',
      this.isEdit = false,
      this.productsDispensary,
      isRoute,
      init()});

  String id;

  String subscriptor;
  String club;
  bool isUpdate;
  bool isActive;
  bool isDelivered;
  int gramsRecipe;

  bool isCancel;
  bool isClubNotifi;
  bool isUserNotifi;
  bool isEdit;
  String dateDelivery;

  DateTime createdAt;
  DateTime updatedAt;
  List<ProductDispensary> productsDispensary;

  factory DispensaryProducts.fromJson(Map<String, dynamic> json) =>
      new DispensaryProducts(
        id: json["id"],
        club: json["club"],
        subscriptor: json["subscriptor"],
        isActive: json["isActive"],
        isDelivered: json["isDelivered"],
        isClubNotifi: json["isClubNotifi"],
        isUserNotifi: json["isUserNotifi"],
        isCancel: json["isCancel"],
        gramsRecipe: json["gramsRecipe"],
        isEdit: json["isEdit"],

        isUpdate: json["isUpdate"],
        dateDelivery: json["dateDelivery"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        productsDispensary: List<ProductDispensary>.from(
            json["productsDispensary"]
                .map((x) => ProductDispensary.fromJson(x))),

        //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "club": club,
        "isActive": isActive,
        "isDelivered": isDelivered,
        "subscriptor": subscriptor,
        "isCancel": isCancel,
        "gramsRecipe": gramsRecipe,
        "isEdit": isEdit,
        "isUpdate": isUpdate,
        "dateDelivery": dateDelivery,
        "isClubNotifi": isClubNotifi,
        "isUserNotifi": isUserNotifi,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "productsDispensary":
            List<dynamic>.from(productsDispensary.map((x) => x.toJson())),
      };
}
