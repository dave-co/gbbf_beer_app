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

  bool showHandpull;
  bool showKeyKeg;
  bool showBottles;

  double abvMin;
  double abvMax;

  bool onlyShowWants;
  bool onlyShowFavourites;
  bool onlyShowTried;

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
      this.showHandpull,
      this.showKeyKeg,
      this.showBottles,
      this.abvMin,
      this.abvMax,
      this.onlyShowWants,
      this.onlyShowFavourites,
      this.onlyShowTried,
      this.beerMetaByFestival
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
      "showHandpull": showHandpull,
      "showKeyKeg": showKeyKeg,
      "showBottles": showBottles,
      "abvMin": abvMin,
      "abvMax": abvMax,
      "onlyShowWants": onlyShowWants,
      "onlyShowFavourites": onlyShowFavourites,
      "onlyShowTried": onlyShowTried,
      "beerMeta" : beerMeta
    };
  }
  factory SavedState.fromJson(dynamic json){
    debugPrint("SavedState.fromJson starting");
    // var beerMetaJsonAll = json['beerMeta'] as Map<String, List<String>>;
    Map beerMetaJsonAll = json['beerMeta'];
    // debugPrint("SavedState.fromJson beerMetaJsonAll=$beerMetaJsonAll");
    // debugPrint("SavedState.fromJson beerMetaJsonAll.runtimeType=${beerMetaJsonAll.runtimeType}");
    Map<String, dynamic> test= beerMetaJsonAll.cast();
    // debugPrint("SavedState.fromJson after cast test=$test");
    Map<String, List<BeerMeta>> output = {};
    for(var key in test.keys){
      List<BeerMeta> beerMeta = [];
      // debugPrint("SavedState.fromJson key=$key");
      for(var entry in test[key]){
        // debugPrint("SavedState.fromJson entry=$entry");
        beerMeta.add(BeerMeta.fromJson(entry));
      }
      output[key] = beerMeta;
    }
    // debugPrint("SavedState.fromJson output=$output");

    // for (var element in test.values) {
    //   debugPrint("value=${element.runtimeType}");
    //   List<dynamic> list = element;
    //   for(var a in list){
    //     debugPrint("a.type==${a.runtimeType}");
    //   }
    // }
    // Map<String, List<BeerMeta>> beerMeta = beerMetaJsonAll.map(
    //         (key, value) => MapEntry(key.toString(), value.map(
    //                 (e) => BeerMeta.fromJson(e)).toList()
    //         )
    // );
    // var beerMetaJsonAll = json['beerMeta'] as List;
    // List<BeerMeta> beerMeta = beerMetaJsonAll.map((beerMetaJson) => BeerMeta.fromJson(beerMetaJson)).toList();
    return SavedState(
        json['festivalName'] as String,
        json['searchText'] as String,
        json['nameSearch'] as bool,
        json['notesSearch'] as bool,
        json['brewerySearch'] as bool,
        json['barSearch'] as bool,
        json['styleSearch'] as bool,
        json['countrySearch'] as bool,
        json['showHandpull'] as bool,
        json['showKeyKeg'] as bool,
        json['showBottles'] as bool,
        json['abvMin'] as double,
        json['abvMax'] as double,
        json['onlyShowWants'] as bool,
        json['onlyShowFavourites'] as bool,
        json['onlyShowTried'] as bool,
        output
        // beerMeta
    );
  }
}