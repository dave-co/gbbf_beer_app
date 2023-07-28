import 'package:flutter/cupertino.dart';

import 'beer_meta.dart';

class SavedState{
  String festivalName;
  // String year;
  String searchText;

  bool nameSearch;
  bool notesSearch;
  bool brewerySearch;
  bool barSearch;
  bool styleSearch;
  bool countrySearch;
  bool tagSearch;

  bool showHandpull;
  bool showKeyKeg;
  bool showBottles;

  double abvMin;
  double abvMax;

  bool onlyShowWants;
  bool onlyShowFavourites;
  bool onlyShowTried;
  bool onlyShowGlutenFree;
  bool onlyShowVegan;

  Map<String, List<BeerMeta>> beerMetaByFestival;
  // List<BeerMeta> beerMetaList;

  SavedState(
      this.festivalName,
      this.searchText,
      this.nameSearch,
      this.notesSearch,
      this.brewerySearch,
      this.barSearch,
      this.styleSearch,
      this.countrySearch,
      this.tagSearch,
      this.showHandpull,
      this.showKeyKeg,
      this.showBottles,
      this.abvMin,
      this.abvMax,
      this.onlyShowWants,
      this.onlyShowFavourites,
      this.onlyShowTried,
      this.beerMetaByFestival,
      this.onlyShowGlutenFree,
      this.onlyShowVegan
      );

  Map toJson(){
    debugPrint("SavedState toJson called");
    // List? beerMeta = beerMetaList.map((i) => i.toJson()).toList();
    Map<String, List<Map>> beerMeta = beerMetaByFestival.map((k,v) => MapEntry(k.toString(), v.map((meta) => meta.toJson()).toList()));
    // debugPrint("SavedState toJson beerMeta=$beerMeta");
    // beerMeta.forEach((key, value) {
    //   debugPrint("key.runtimeType=${key.runtimeType} value.runtimeType==${value.runtimeType}");
    //
    // });
    return {
      "festivalName" : festivalName,
      "searchText": searchText,
      "nameSearch": nameSearch,
      "notesSearch": notesSearch,
      "brewerySearch": brewerySearch,
      "barSearch": barSearch,
      "styleSearch": styleSearch,
      "countrySearch": countrySearch,
      "tagSearch": tagSearch,
      "showHandpull": showHandpull,
      "showKeyKeg": showKeyKeg,
      "showBottles": showBottles,
      "abvMin": abvMin,
      "abvMax": abvMax,
      "onlyShowWants": onlyShowWants,
      "onlyShowFavourites": onlyShowFavourites,
      "onlyShowTried": onlyShowTried,
      "beerMeta" : beerMeta,
      "onlyShowGlutenFree": onlyShowGlutenFree,
      "onlyShowVegan": onlyShowVegan
    };
  }
  factory SavedState.fromJson(dynamic json){
    debugPrint("SavedState.fromJson starting");
    Map beerMetaJsonAll = json['beerMeta'];
    Map<String, dynamic> test= beerMetaJsonAll.cast();
    Map<String, List<BeerMeta>> output = {};
    for(var key in test.keys){
      List<BeerMeta> beerMeta = [];
      for(var entry in test[key]){
        beerMeta.add(BeerMeta.fromJson(entry));
      }
      output[key] = beerMeta;
    }
    return SavedState(
        json['festivalName'] as String,
        json['searchText'] as String,
        json['nameSearch'] as bool,
        json['notesSearch'] as bool,
        json['brewerySearch'] as bool,
        json['barSearch'] as bool,
        json['styleSearch'] as bool,
        json['countrySearch'] as bool,
        json['tagSearch'] == null ? false : json['tagSearch'] as bool,
        json['showHandpull'] as bool,
        json['showKeyKeg'] as bool,
        json['showBottles'] as bool,
        json['abvMin'] as double,
        json['abvMax'] as double,
        json['onlyShowWants'] as bool,
        json['onlyShowFavourites'] as bool,
        json['onlyShowTried'] as bool,
        output,
        json['onlyShowGlutenFree'] == null ? false : json['onlyShowGlutenFree'] as bool,
        json['onlyShowVegan'] == null ? false : json['onlyShowVegan'] as bool
    );
  }
}