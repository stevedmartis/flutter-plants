// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_plants/models/product_principal.dart';

DispensaryProductsProfileResponse dispensaryProductsResponseFromJson(
        String str) =>
    DispensaryProductsProfileResponse.fromJson(json.decode(str));

String catalogosProductsResponseToJson(
        DispensaryProductsProfileResponse data) =>
    json.encode(data.toJson());

class DispensaryProductsProfileResponse {
  DispensaryProductsProfileResponse({
    this.ok,
    this.productsProfileDispensary,
  });

  bool ok;

  List<ProductProfile> productsProfileDispensary;

  factory DispensaryProductsProfileResponse.fromJson(
          Map<String, dynamic> json) =>
      DispensaryProductsProfileResponse(
        ok: json["ok"],
        productsProfileDispensary: List<ProductProfile>.from(
            json["productsProfileDispensary"]
                .map((x) => ProductProfile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "productsProfileDispensary": List<dynamic>.from(
            productsProfileDispensary.map((x) => x.toJson())),
      };

  DispensaryProductsProfileResponse.withError(String errorValue);
}
