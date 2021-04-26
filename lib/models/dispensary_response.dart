// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/dispensary.dart';
import 'package:chat/models/plant.dart';

DispensaryResponse dispensaryResponseFromJson(String str) =>
    DispensaryResponse.fromJson(json.decode(str));

String dispensaryResponseToJson(DispensaryResponse data) =>
    json.encode(data.toJson());

class DispensaryResponse {
  DispensaryResponse({this.ok, this.dispensary});

  bool ok;
  Dispensary dispensary;

  factory DispensaryResponse.fromJson(Map<String, dynamic> json) =>
      DispensaryResponse(
          ok: json["ok"], dispensary: Dispensary.fromJson(json["dispensary"]));

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "dispensary": dispensary.toJson(),
      };

  DispensaryResponse.withError(String errorValue);
}
