// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

ProductDispensary productFromJson(String str) =>
    ProductDispensary.fromJson(json.decode(str));

String productToJson(ProductDispensary data) => json.encode(data.toJson());

class ProductDispensary {
  ProductDispensary(
      {this.id,
      this.product,
      this.dispensary,
      this.quantity,
      this.createdAt,
      this.updatedAt

      //this.products
      });
  String id;
  String product;
  String dispensary;
  int quantity;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProductDispensary.fromJson(Map<String, dynamic> json) =>
      ProductDispensary(
        id: json["id"],
        product: json["product"],
        dispensary: json["dispensary"],
        quantity: json["quantity"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product,
        "dispensary": dispensary,
        "quantity": quantity,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
