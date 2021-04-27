// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/dispensary.dart';
import 'package:chat/models/products.dart';

DispensaryproductsResponse dispensaryProductsResponseFromJson(String str) =>
    DispensaryproductsResponse.fromJson(json.decode(str));

String dispensaryProductsResponseToJson(DispensaryproductsResponse data) =>
    json.encode(data.toJson());

class DispensaryproductsResponse {
  DispensaryproductsResponse(
      {this.ok, this.dispensary, this.productsDispensary});

  bool ok;
  Dispensary dispensary;

  List<Product> productsDispensary;

  factory DispensaryproductsResponse.fromJson(Map<String, dynamic> json) =>
      DispensaryproductsResponse(
        ok: json["ok"],
        dispensary: Dispensary.fromJson(
          json["dispensary"],
        ),
        productsDispensary: List<Product>.from(
            json["productsDispensary"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "dispensary": dispensary.toJson(),
        "productsDispensary":
            List<dynamic>.from(productsDispensary.map((x) => x.toJson())),
      };

  DispensaryproductsResponse.withError(String errorValue);
}
