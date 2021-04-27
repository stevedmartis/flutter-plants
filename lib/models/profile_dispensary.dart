//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/dispensary.dart';
import 'package:chat/models/profiles.dart';

ProfileDispensary profileDispensaryResponseFromJson(String str) =>
    ProfileDispensary.fromJson(json.decode(str));

String profileDispensaryResponseToJson(ProfileDispensary data) =>
    json.encode(data.toJson());

class ProfileDispensary {
  ProfileDispensary({this.ok, this.dispensary, this.profile});

  bool ok;
  Profiles profile;
  Dispensary dispensary;

  factory ProfileDispensary.fromJson(Map<String, dynamic> json) =>
      ProfileDispensary(
        dispensary: Dispensary.fromJson(json["dispensary"]),
        profile: Profiles.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "dispensary": dispensary.toJson(),
        "profile": profile.toJson(),
      };

  ProfileDispensary.withError(String errorValue);
}
