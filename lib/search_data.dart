class SearchData {
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

  SearchData(this.searchText,
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
      this.onlyShowTried
      );
}