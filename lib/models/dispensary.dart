import 'dart:convert';

Dispensary dispensaryFromJson(String str) =>
    Dispensary.fromJson(json.decode(str));

String subscribeToJson(Dispensary data) => json.encode(data.toJson());

class Dispensary {
  Dispensary(
      {this.id = "",
      this.subscriptor = "",
      this.club = "",
      this.createdAt,
      this.updatedAt,
      this.gramsRecipe = 0,
      this.isUpload = false,
      this.isActive = false,
      this.isDelivery = false,
      this.isCancel = false,
      this.isClubNotifi = false,
      this.isUserNotifi = false,
      this.dateDelivery = '',
      this.isEdit = false,
      isRoute,
      init()});

  String id;

  String subscriptor;
  String club;
  bool isUpload;
  bool isActive;
  bool isDelivery;
  int gramsRecipe;

  bool isCancel;
  bool isClubNotifi;
  bool isUserNotifi;
  bool isEdit;
  String dateDelivery;

  DateTime createdAt;
  DateTime updatedAt;

  factory Dispensary.fromJson(Map<String, dynamic> json) => new Dispensary(
        id: json["id"],
        club: json["club"],
        subscriptor: json["subscriptor"],
        isActive: json["isActive"],
        isDelivery: json["isDelivery"],
        isClubNotifi: json["isClubNotifi"],
        isUserNotifi: json["isUserNotifi"],
        isCancel: json["isCancel"],
        gramsRecipe: json["gramsRecipe"],
        isEdit: json["isEdit"],

        isUpload: json["isUpload"],
        dateDelivery: json["dateDelivery"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),

        //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "club": club,
        "isActive": isActive,
        "isDelivery": isDelivery,
        "subscriptor": subscriptor,
        "isCancel": isCancel,
        "gramsRecipe": gramsRecipe,
        "isEdit": isEdit,
        "isUpload": isUpload,
        "dateDelivery": dateDelivery,
        "isClubNotifi": isClubNotifi,
        "isUserNotifi": isUserNotifi,
        "createdAt": createdAt,
        "updatedAt": updatedAt
      };
}
