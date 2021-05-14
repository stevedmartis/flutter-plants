// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_plants/models/profile_dispensary.dart';

ProfilesDispensariesResponse profilesDispensariesResponseFromJson(String str) =>
    ProfilesDispensariesResponse.fromJson(json.decode(str));

String profilesDispensariesResponseToJson(ProfilesDispensariesResponse data) =>
    json.encode(data.toJson());

class ProfilesDispensariesResponse {
  ProfilesDispensariesResponse({this.ok, this.profilesDispensaries});

  bool ok;
  List<ProfileDispensary> profilesDispensaries;

  factory ProfilesDispensariesResponse.fromJson(Map<String, dynamic> json) =>
      ProfilesDispensariesResponse(
        ok: json["ok"],
        profilesDispensaries: List<ProfileDispensary>.from(
            json["profilesDispensaries"]
                .map((x) => ProfileDispensary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "profilesDispensaries":
            List<dynamic>.from(profilesDispensaries.map((x) => x.toJson())),
      };

  ProfilesDispensariesResponse.withError(String errorValue);
}
