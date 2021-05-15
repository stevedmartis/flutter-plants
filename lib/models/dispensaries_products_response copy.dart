// To parse this JSON data, do
//
//     final store = storeFromJson(jsonString);

import 'dart:convert';

import 'package:leafety/models/products.dart';

DispensariesProductsResponse storeFromJson(String str) =>
    DispensariesProductsResponse.fromJson(json.decode(str));

String storeToJson(DispensariesProduct data) => json.encode(data.toJson());

class DispensariesProductsResponse {
  DispensariesProductsResponse({
    this.ok,
    this.dispensariesProducts,
  });

  bool ok;
  List<DispensariesProduct> dispensariesProducts;

  factory DispensariesProductsResponse.fromJson(Map<String, dynamic> json) =>
      DispensariesProductsResponse(
        ok: json["ok"],
        dispensariesProducts: List<DispensariesProduct>.from(
            json["dispensariesProducts"]
                .map((x) => DispensariesProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "dispensariesProducts":
            List<dynamic>.from(dispensariesProducts.map((x) => x.toJson())),
      };

  DispensariesProductsResponse.withError(String errorValue);
}

class DispensariesProduct {
  DispensariesProduct({
    this.id = "1",
    this.subscriptor = "",
    this.gramsRecipe = 0,
    this.club = "",
    this.dateDelivery = "",
    this.isActive = false,
    this.isDelivered = false,
    this.isCancel = false,
    this.isUpdate = false,
    this.isUserNotifi = false,
    this.isClubNotifi = false,
    this.isEdit = false,
    this.createdAt,
    this.updatedAt,
    this.productsDispensary,
  });

  String id;
  String subscriptor;
  int gramsRecipe;
  String club;
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
  List<Product> productsDispensary;

  factory DispensariesProduct.fromJson(Map<String, dynamic> json) =>
      DispensariesProduct(
        id: json["id"],
        subscriptor: json["subscriptor"],
        gramsRecipe: json["gramsRecipe"],
        club: json["club"],
        dateDelivery: json["dateDelivery"],
        isActive: json["isActive"],
        isDelivered: json["isDelivered"],
        isCancel: json["isCancel"],
        isUpdate: json["isUpdate"],
        isUserNotifi: json["isUserNotifi"],
        isClubNotifi: json["isClubNotifi"],
        isEdit: json["isEdit"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        productsDispensary: List<Product>.from(
            json["productsDispensary"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subscriptor": subscriptor,
        "gramsRecipe": gramsRecipe,
        "club": club,
        "dateDelivery": dateDelivery,
        "isActive": isActive,
        "isDelivered": isDelivered,
        "isCancel": isCancel,
        "isUpdate": isUpdate,
        "isUserNotifi": isUserNotifi,
        "isClubNotifi": isClubNotifi,
        "isEdit": isEdit,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "productsDispensary":
            List<dynamic>.from(productsDispensary.map((x) => x.toJson())),
      };
}
