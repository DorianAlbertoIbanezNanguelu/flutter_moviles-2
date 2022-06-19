// ignore_for_file: file_names

import 'dart:convert';

PetItemInfo petItemInfoFromJson(String str) =>
    PetItemInfo.fromJson(json.decode(str));

String petItemInfoToJson(PetItemInfo data) => json.encode(data.toJson());

class PetItemInfo {
  PetItemInfo({
    required this.code,
    required this.globalMessage,
    required this.PetTaxonomias,
  });

  bool code;
  String globalMessage;
  List<PetTax> PetTaxonomias;

  factory PetItemInfo.fromJson(Map<String, dynamic> json) => PetItemInfo(
        code: json["code"],
        globalMessage: json["globalMessage"],
        PetTaxonomias: List<PetTax>.from(
            json["PetTaxonomias"].map((x) => PetTax.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "globalMessage": globalMessage,
        "PetTaxonomias":
            List<dynamic>.from(PetTaxonomias.map((x) => x.toJson()),),
      };
}

class PetTax {
  PetTax({
    required this.pet,
  });

  List<Pet> pet;

  factory PetTax.fromJson(Map<String, dynamic> json) => PetTax(
        pet: List<Pet>.from(json["pet"].map((x) => Pet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pet": List<dynamic>.from(pet.map((x) => x.toJson())),
      };
}

class Pet {
  Pet({
    required this.pet,
    required this.detallePets,
  });

  String pet;
  List<DetallePet> detallePets;

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        pet: json["pet"],
        detallePets: List<DetallePet>.from(
            json["detallePets"].map((x) => DetallePet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pet": pet,
        "detallePets": List<dynamic>.from(detallePets.map((x) => x.toJson())),
      };
}

class DetallePet {
  DetallePet({
    required this.item,
  });

  String item;

  factory DetallePet.fromJson(Map<String, dynamic> json) => DetallePet(
        item: json["item"],
      );

  Map<String, dynamic> toJson() => {
        "item": item,
      };
}
