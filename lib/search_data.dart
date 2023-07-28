class SearchData {
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
  String activeFestivalName;
  bool onlyShowGlutenFree;
  bool onlyShowVegan;

  SearchData(this.searchText,
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
      this.activeFestivalName,
      this.onlyShowGlutenFree,
      this.onlyShowVegan
      );
}