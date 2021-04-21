// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/products.dart';

DispensaryProductsResponse dispensaryProductsResponseFromJson(String str) =>
    DispensaryProductsResponse.fromJson(json.decode(str));

String catalogosProductsResponseToJson(DispensaryProductsResponse data) =>
    json.encode(data.toJson());

class DispensaryProductsResponse {
  DispensaryProductsResponse({
    this.ok,
    this.products,
  });

  bool ok;

  List<Product> products;

  factory DispensaryProductsResponse.fromJson(Map<String, dynamic> json) =>
      DispensaryProductsResponse(
        ok: json["ok"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };

  DispensaryProductsResponse.withError(String errorValue);
}
