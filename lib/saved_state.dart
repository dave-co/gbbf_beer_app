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
    // List? beerMeta = beerMetaList.map((i) => i.toJson()).toList();
    Map? beerMeta = beerMetaByFestival.map((k,v) => MapEntry(k, v.map((meta) => meta.toJson())));
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
    var beerMetaJsonAll = json['beerMeta'] as Map<String, List<String>>;
    Map<String, List<BeerMeta>> beerMeta = beerMetaJsonAll.map(
            (key, value) => MapEntry(key, value.map(
                    (e) => BeerMeta.fromJson(e)).toList()
            )
    );
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
        beerMeta
    );
  }
}