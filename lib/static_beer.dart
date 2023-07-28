import 'package:flutter/cupertino.dart';

class StaticBeer {
  int id;
  String name;
  double abv;
  String style;
  String barCode;
  String notes;
  String brewery;
  String country;
  String untappdUrl;
  String dispenseMethod;
  String colour;
  String styleImage;
  String barName;
  String barLocation;
  List<String> tags;
  bool vegan;
  bool glutenFree;

  StaticBeer(this.id, this.name, this.abv, this.style, this.barCode, this.notes,
      this.brewery, this.country, this.untappdUrl, this.dispenseMethod,
      this.colour, this.styleImage, this.barName, this.barLocation, this.tags,
      this.vegan, this.glutenFree);

  factory StaticBeer.fromJson(dynamic json) {
    // debugPrint("json['id']=${json['id']}");
    List<dynamic> tagListDynamic = json['tags'] ?? [];
    List<String> tagListString = tagListDynamic.map((e) => e.toString()).toList();
    return StaticBeer(json['id'] as int,
        json['name'] as String,
        double.parse(json['abv'] as String),
        json['style'] as String,
        json['barCode'] as String,
        json['notes'] as String,
        json['brewery'] as String,
        json['country'] == null ? '' : json['country'] as String,
        json['untappdUrl'] == null ? '' : json['untappdUrl'] as String,
        json['dispenseMethod'] == null ? 'unknown' : json['dispenseMethod'] as String,
        json['colour'] == null ? '' : json['colour'] as String,
        json['styleImage'] == null ? '' : json['styleImage'] as String,
        json['barName'] == null ? '' : json['barName'] as String,
        json['barLocation'] == null ? '' : json['barLocation'] as String,
        tagListString,
        json['vegan'] == null ? false : json['vegan'] as bool,
        json['glutenFree'] == null ? false : json['glutenFree'] as bool
    );
  }
}