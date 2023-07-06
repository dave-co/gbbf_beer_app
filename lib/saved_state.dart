import 'beer_meta.dart';

class SavedState{
  String year;
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

  List<BeerMeta> beerMetaList;

  SavedState(
      this.year,
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
      this.beerMetaList
      );

  Map toJson(){
    List? beerMeta = beerMetaList.map((i) => i.toJson()).toList();
    return {
      "year" : year,
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
    var beerMetaJsonAll = json['beerMeta'] as List;
    List<BeerMeta> beerMeta = beerMetaJsonAll.map((beerMetaJson) => BeerMeta.fromJson(beerMetaJson)).toList();
    return SavedState(
        json['year'] as String,
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