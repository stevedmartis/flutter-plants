import 'dart:convert';

Plant plantFromJson(String str) => Plant.fromJson(json.decode(str));

String plantToJson(Plant data) => json.encode(data.toJson());

class Plant {
  Plant(
      {this.id,
      this.user,
      this.name = "",
      this.description = "",
      this.quantity = "",
      //  this.sexo = "0",
      this.germinated = "",
      this.flowering = "",
      this.pot = "",
      this.room,
      this.cbd = "",
      this.thc = "",
      this.createdAt,
      this.updatedAt,
      this.coverImage = "",
      this.position,
      isRoute,
      init()});

  String id;
  String name;
  String description;
  String quantity;

  String sexo;

  String cbd;
  String thc;
  String user;
  String room;
  String germinated;
  String flowering;
  String pot;
  String coverImage;

  int position;
  DateTime createdAt;
  DateTime updatedAt;

  factory Plant.fromJson(Map<String, dynamic> json) => new Plant(
      id: json["id"],
      user: json['user'],
      room: json['room'],
      name: json["name"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      description: json["description"],
      quantity: json["quantity"],
      //  sexo: json["sexo"],
      germinated: json["germinated"],
      flowering: json["flowering"],
      pot: json["pot"],
      cbd: json["cbd"],
      thc: json["thc"],
      coverImage: json["coverImage"],
      position: json["position"]
      //images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "room": room,
        "name": name,
        "description": description,
        "quantity": quantity,
        //   "sexo": sexo,
        "germinated": germinated,
        "flowering": flowering,
        "pot": pot,
        "cbd": cbd,
        "thc": thc,
        "coverImage": coverImage,
        "position": position
        // "images": List<Image>.from(images.map((x) => x)),
      };

  getCoverImg() {
    if (coverImage == "") {
      var imageDefault =
          "https://leafety-images.s3.us-east-2.amazonaws.com/global/default_banner.jpeg";
      return imageDefault;
    } else {
      return coverImage;
    }
  }
}
