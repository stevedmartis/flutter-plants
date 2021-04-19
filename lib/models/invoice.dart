import 'package:flutter/material.dart';

class Customer {
  final String name;
  final String email;

  const Customer({
    @required this.name,
    @required this.email,
  });
}

class Profile {
  final String name;
  final String about;
  final String username;
  final String siteInfo;
  final String email;
  final String imageAvatar;
  final String rutClub;
  final bool isClub;

  const Profile(
      {@required this.rutClub,
      @required this.name,
      @required this.about,
      @required this.username,
      @required this.siteInfo,
      @required this.email,
      @required this.imageAvatar,
      @required this.isClub});
}

class Report {
  final InvoiceInfo info;
  final Profile profile;
  final Customer customer;
  final List<RoomsItem> rooms;
  final List<PlantsItem> plants;
  final List<VisitsItem> visits;

  const Report({
    @required this.info,
    @required this.profile,
    @required this.customer,
    @required this.rooms,
    @required this.plants,
    @required this.visits,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    @required this.description,
    @required this.number,
    @required this.date,
    @required this.dueDate,
  });
}

class RoomsItem {
  final String name;
  final String description;
  final DateTime date;
  final int totalPlants;
  final int totalAirs;
  final int totalLights;

  const RoomsItem({
    @required this.name,
    this.description,
    @required this.date,
    @required this.totalPlants,
    @required this.totalAirs,
    @required this.totalLights,
  });
}

class PlantsItem {
  final String name;
  final String description;
  final DateTime date;
  final String quantity;
  final String cbd;
  final String thc;
  final String germination;
  final String floration;

  const PlantsItem(
      {@required this.name,
      this.description,
      @required this.date,
      @required this.quantity,
      @required this.cbd,
      @required this.thc,
      @required this.germination,
      @required this.floration});
}

class VisitsItem {
  final String description;
  final DateTime date;
  final String degrees;
  final String ml;
  final String ph;
  final String electro;
  final String mlAbono;
  final String nameAbono;
  final String grams;

  const VisitsItem(
      {this.description,
      @required this.date,
      @required this.degrees,
      @required this.ml,
      @required this.ph,
      @required this.electro,
      @required this.nameAbono,
      @required this.mlAbono,
      @required this.grams});
}
