import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gbbf_beer_app/labelled_checkbox.dart';
import 'package:gbbf_beer_app/static_beer.dart';
import 'package:gbbf_beer_app/search_data.dart';
import 'package:gbbf_beer_app/settings.dart';
import 'package:gbbf_beer_app/search.dart';
import 'package:gbbf_beer_app/saved_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gbbf_beer_app/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'beer_lists.dart';
import 'beer_meta.dart';
import 'festival.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GBBF Beers',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GBBF Beers'),
    );
  }
}

class MyHomePage extends StatefulHookWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool stateInitialised = false;
  // List<StaticBeer> beers = [];
  var filteredBeers = [];

  // map of year to beer meta data
  Map<String, List<BeerMeta>> beerMetaData = {};

  // String year = "2023";
  // String festivalName = '';
  late Festival activeFestival;
  String searchText = '';

  bool nameSearch = true;
  bool notesSearch = false;
  bool brewerySearch = false;
  bool barSearch = true;
  bool styleSearch = false;
  bool countrySearch = false;

  bool showHandpull = true;
  bool showKeyKeg = true;
  bool showBottles = false;

  double abvMin = 4;
  double abvMax = 12;

  bool onlyShowWants = false;
  bool onlyShowFavourites = false;
  bool onlyShowTried = false;

  List<Festival> festivals = [];

  @override
  void initState() {
    super.initState();
    debugPrint("initState");
    _initFestivals();
    debugPrint("initState _initFestivals complete");
    _loadSavedState().then((_) {
      _searchBeers();
      }
    );
    debugPrint("initState _loadSavedState complete");
    //     .then((_) {
    //   debugPrint("initState");
    //   // beers = _loadStaticBeers(year);
    //   // beerMetaData[year] = _checkMetaData();
    //   _createMetaData(beers);
    // });
  }

  void _initFestivals() {
    festivals.add(Festival(
      // "gbbf-2003",
        "GBBF 2023",
        List.generate(beers2023.length, (index) =>
            StaticBeer.fromJson(jsonDecode(beers2023[index])))));
    festivals.add(Festival(
      // "gbbf-2002",
        "GBBF 2022",
        List.generate(beers2022.length, (index) =>
            StaticBeer.fromJson(jsonDecode(beers2022[index])))));
    // default festival is top one. This may be overridden by the saved state when it loads.
    activeFestival = festivals[0];
  }

  Festival _getFestival(String festivalName) {
    if (!festivals.any((element) => element.name == festivalName)) {
      debugPrint("festivalName '$festivalName' not found, using default");
      return festivals[0];
    }
    return festivals.firstWhere((element) => element.name == festivalName);
  }

  void _settingsResult(String newFestivalName) {
    debugPrint("returned from settings with newFestivalName=$newFestivalName");
    setState(() {
      activeFestival = _getFestival(newFestivalName);
    });
  }

  void _searchFieldsResult(SearchData searchData) {
    setState(() {
      searchText = searchData.searchText;
      nameSearch = searchData.nameSearch;
      notesSearch = searchData.notesSearch;
      brewerySearch = searchData.brewerySearch;
      barSearch = searchData.barSearch;
      styleSearch = searchData.styleSearch;
      countrySearch = searchData.countrySearch;
      showHandpull = searchData.showHandpull;
      showKeyKeg = searchData.showKeyKeg;
      showBottles = searchData.showBottles;
      abvMin = searchData.abvMin;
      abvMax = searchData.abvMax;
      onlyShowWants = searchData.onlyShowWants;
      onlyShowFavourites = searchData.onlyShowFavourites;
      onlyShowTried = searchData.onlyShowTried;
    });
  }

  BeerMeta getBeerMeta(int beerId){
    return getFestivalBeerMetaData()[beerId];
  }

  List<BeerMeta> getFestivalBeerMetaData() {
    if(!beerMetaData.containsKey(activeFestival.name)) return [];
    return beerMetaData[activeFestival.name]!;
  }

  List<StaticBeer> getStaticBeersForFestival(){
    return activeFestival.staticBeers;
  }

  void _searchBeers() {
    debugPrint("_searchBeers called");
    List<StaticBeer> beers = getStaticBeersForFestival();
    List<BeerMeta> meta = getFestivalBeerMetaData();
    //TODO maybe remove this?
    if (beers.length < 2) {
      return;
    }
    if (meta.length != beers.length) {
      debugPrint("meta.length=${meta.length} beers.length=${beers.length} - search skipped");
      return;
    }
    setState(() {
      filteredBeers = beers.where((beer) {
        // check abv first, if outside the range we don't care about the rest of the search options
        if (beer.abv < abvMin || (abvMax != maxAbv && beer.abv > abvMax)) {
          return false;
        }
        // now check dispense method
        if (beer.dispenseMethod == "Handpull" && !showHandpull ||
            beer.dispenseMethod == "KeyKeg" && !showKeyKeg ||
            beer.dispenseMethod == "Bottle" && !showBottles) {
          return false;
        }
        // List<BeerMeta>? list = beerMetaData[year];
        // list![beer.id];
        // BeerMeta beerMeta = beerMetaData[year]![beer.id];
        BeerMeta beerMeta = meta[beer.id];
        if (onlyShowTried == true && !beerMeta.tried) {
          return false;
        }
        if (onlyShowWants == true && !beerMeta.want) {
          return false;
        }
        if (onlyShowFavourites == true && !beerMeta.favourite) {
          return false;
        }

        String text = searchText.toLowerCase();
        if (nameSearch && beer.name.toLowerCase().contains(text)) {
          return true;
        }
        if (notesSearch && beer.notes.toLowerCase().contains(text)) {
          return true;
        }
        if (brewerySearch && beer.brewery.toLowerCase().contains(text)) {
          return true;
        }
        if (barSearch && beer.barCode.toLowerCase().contains(text)) {
          return true;
        }
        if (styleSearch && beer.style.toLowerCase().contains(text)) {
          return true;
        }
        if (countrySearch && beer.country.toLowerCase().contains(text)) {
          return true;
        }

        if (!nameSearch && !notesSearch && !brewerySearch && !barSearch &&
            !styleSearch && !countrySearch) {
          return true;
        }
        return false;
      }).toList();
      debugPrint('filteredBeers size= ${filteredBeers.length}');
    });
  }

  // List<BeerMeta> _cloneMeta(){
  //   return List<BeerMeta>.of(beerMetaData);
  // }

  void _updateMeta(int beerId, String propertyName, dynamic value) {
    debugPrint("beerId=$beerId propertyName=$propertyName value=$value");
    Map<String, List<BeerMeta>> clone = Map.of(beerMetaData);
    BeerMeta beerMeta = clone[activeFestival.name]![beerId];
    beerMeta.set(propertyName, value);
    if(propertyName == 'tried' && value is bool && value){
      beerMeta.want = false;
    }
    setState(() {
      beerMetaData = clone;
    });

    // List<BeerMeta> clone = List<BeerMeta>.of(beerMetaData);
    // clone[beerId].set(propertyName, value);
    // if (propertyName == 'tried' && value is bool && value) {
    //   clone[beerId].want = false;
    // }
    // setState(() {
    //   beerMetaData = clone;
    // });
  }
  Future<void> _openUrl(StaticBeer staticBeer) async {
    String url = staticBeer.untappdUrl == '' ? _createUntappdSearchUrl(staticBeer) : staticBeer.untappdUrl;
    debugPrint("_openUrl url=$url");
    // if(url == ''){
    //   debugPrint("_openUrl no url");
    //   return;
    // }
    final parsedUrl = Uri.parse(url);
    await launchUrl(parsedUrl, mode: LaunchMode.externalApplication);
  }

  String _createUntappdSearchUrl(StaticBeer staticBeer){
    String query = Uri.encodeComponent("${staticBeer.brewery} ${staticBeer.name}");
    return "https://untappd.com/search?q=$query&type=beer&sort=all";
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _saveState();
      _searchBeers();
      return () {};
    }, [searchText, nameSearch, notesSearch, brewerySearch, barSearch,
      styleSearch, countrySearch, showHandpull, showKeyKeg, showBottles,
      abvMin, abvMax, onlyShowWants, onlyShowFavourites, onlyShowTried]);

    // useEffect(() {
    //   beers = _loadStaticBeers(year);
    //   _saveState();
    //   _searchBeers();
    //   return () {};
    // }, [year]);

    useEffect(() {
      _saveState();
      _searchBeers();
      return () {};
    }, [activeFestival]);

    useEffect(() {
      _saveState();
      return () {};
    }, [beerMetaData]);

    // updateMeta(Function f){
    //
    // }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('${activeFestival.name} Beers'),
        actions: [
          Padding(
              padding: const EdgeInsets.only(top: 17, right: 20),
              child:Text("${filteredBeers.length}", textScaleFactor: 1.3)
          ),
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Search(
                                    searchText,
                                    nameSearch,
                                    notesSearch,
                                    brewerySearch,
                                    barSearch,
                                    styleSearch,
                                    countrySearch,
                                    showHandpull,
                                    showKeyKeg,
                                    showBottles,
                                    abvMin,
                                    abvMax,
                                    onlyShowWants,
                                    onlyShowFavourites,
                                    onlyShowTried
                                )
                        )
                    ).then((value) => _searchFieldsResult(value));
                  },
                  child: const Icon(
                    Icons.search,
                    size: 26,
                  )
              )
          ),
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Settings(
                                activeFestival.name,
                                List.generate(festivals.length, (index) => festivals[index].name)
                            )
                        ))
                        .then((value) => _settingsResult(value));
                  },
                  child: const Icon(
                    Icons.settings,
                    size: 26,
                  )
              )
          )
        ],
      ),
      body: ListView.builder(
          itemCount: filteredBeers.length,
          itemBuilder: (BuildContext context, int i) {
            var beerId = filteredBeers[i].id;
            return GestureDetector(
              onTap: () =>
                  _updateMeta(
                      beerId, 'showDetail', !getBeerMeta(beerId).showDetail),
              child: Column(
                children: [
                  const Divider(height: 10,),
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child:Text(filteredBeers[i].name))
                      ),
                      Expanded(
                          flex: 2,
                          child: Text('${filteredBeers[i].abv}%')
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(filteredBeers[i].dispenseMethod)
                      ),
                    ],
                  ),
                  Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 14),
                                child: Text('${filteredBeers[i].brewery}')
                            )
                        ),
                        Expanded(
                            flex: 2,
                            child: Text(filteredBeers[i].style)
                        ),
                        Expanded(
                            flex: 1,
                            child: Text(filteredBeers[i].barCode)
                        ),
                        Expanded(
                            flex: 1,
                            child: _getLabelWidget(getBeerMeta(beerId))
                        ),
                      ]),
                  Visibility(
                      visible: getBeerMeta(beerId).showDetail,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                Expanded(child: Text(filteredBeers[i].notes))
                              ],
                            )
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () => _openUrl(filteredBeers[i]),
                                      child: Image.asset(
                                        filteredBeers[i].untappdUrl == null || filteredBeers[i].untappdUrl == ''
                                            ? 'assets/images/untappd-512-grey.png'
                                            : 'assets/images/untappd-512.png',
                                        height: 30,
                                        width: 30
                                      )
                                  )
                              ),
                              Expanded(
                                  flex: 2,
                                  child: LabelledCheckbox(
                                      text: const Text("Want", textScaleFactor: 1.1,),
                                      padding: const EdgeInsets.only(left: 1),
                                      value: getBeerMeta(beerId).want,
                                      onChanged: (bool? value) {
                                        _updateMeta(beerId, 'want',
                                            !getBeerMeta(beerId).want);
                                      })
                              ),
                              Expanded(
                                  flex: 2,
                                  child: LabelledCheckbox(
                                      text: const Text("Tried", textScaleFactor: 1.1,),
                                      padding: const EdgeInsets.only(left: 1),
                                      activeColor: Colors.orange,
                                      value: getBeerMeta(beerId).tried,
                                      onChanged: (bool? value) {
                                        _updateMeta(beerId, 'tried',
                                            !getBeerMeta(beerId).tried);
                                      })
                              ),
                              Expanded(
                                  flex: 2,
                                  child: LabelledCheckbox(
                                      text: const Text("Favourite", textScaleFactor: 1.1,),
                                      padding: const EdgeInsets.only(left: 1),
                                      value: getBeerMeta(beerId).favourite,
                                      activeColor: Colors.purple,
                                      onChanged: (bool? value) {
                                        _updateMeta(beerId, 'favourite',
                                            !getBeerMeta(beerId).favourite);
                                      })
                              ),
                            ]
                          ),
                          Visibility(
                              visible: getBeerMeta(beerId).tried,
                              child: Row(
                                  children: _createRatingStars(
                                      getBeerMeta(beerId), beerId)
                              )
                          )
                        ],
                      )
                  )
                ],
              ),
            );
          })
      , // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String _getLabel(BeerMeta beerMeta) {
    if (beerMeta.favourite) {
      return 'Fave';
    } else if (beerMeta.tried) {
      return 'Tried';
    } else if (beerMeta.want) {
      return 'Want';
    }
    return '';
  }

  MaterialColor _getColour(BeerMeta beerMeta){
    if(beerMeta.favourite){
      return Colors.purple;
    }
    if(beerMeta.tried){
      return Colors.orange;
    }
    return Colors.blue;
  }

  Widget _getLabelWidget(BeerMeta beerMeta){
    String label = _getLabel(beerMeta);
    if(label == '') return const Text('');
    Container container = Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
            width: 1,
            color: _getColour(beerMeta)
        ),
      ),
      child: Text(label)
    );
    return container;
  }

  List<Widget> _createRatingStars(BeerMeta beerMeta, beerId) {
    List<Widget> stars = [
      Expanded(flex: 2, child: beerMeta.rating == 0
          ? const Text('Rating: ')
          : GestureDetector(
        onTap: () => _updateMeta(beerId, 'rating', 0),
        //   onTap: (){
        //   setState(() {
        //     beerMetaData[beerId].rating = 0;
        //   });
        // },
        child: const Text('Clear'),
      )
      ),
      _createStar(1, beerMeta.rating, beerId),
      _createStar(2, beerMeta.rating, beerId),
      _createStar(3, beerMeta.rating, beerId),
      _createStar(4, beerMeta.rating, beerId),
      _createStar(5, beerMeta.rating, beerId),
      const Expanded(flex: 2, child: Text(''),)
    ];
    return stars;
  }

  GestureDetector _createStar(int threshold, int rating, int beerId) {
    return GestureDetector(
      onTap: () => _updateMeta(beerId, 'rating', threshold),
      // onTap: (){
      //   setState(() {
      //     beerMetaData[beerId].rating = threshold;
      //   });
      // },
      child: rating < threshold
      // ignore: prefer_const_constructors
          ? Icon(color: Colors.orange, Icons.star_outline_rounded)
      // ignore: prefer_const_constructors
          : Icon(color: Colors.orange, Icons.star_rate_rounded),
    );
  }

  Future<void> _saveState() async {
    if(stateInitialised){
      debugPrint("saving state");
      // Map<String, List<BeerMeta>> metaToSave = {
      //   for (var f in festivals) f.name: f.beerMeta ?? []
      // };
      // debugPrint("metaToSave=$metaToSave");
      final prefs = await SharedPreferences.getInstance();
      String festivalName = activeFestival.name;
      String json = jsonEncode(SavedState(
          festivalName
          ,searchText
          ,nameSearch
          ,notesSearch
          ,brewerySearch
          ,barSearch
          ,styleSearch
          ,countrySearch
          ,showHandpull
          ,showKeyKeg
          ,showBottles
          ,abvMin
          ,abvMax
          ,onlyShowWants
          ,onlyShowFavourites
          ,onlyShowTried
          ,beerMetaData
          // ,metaToSave
      ).toJson());
      prefs.setString("state", json);

    } else {
      debugPrint("saveState - state not initialised");
    }
  }

  // List<BeerMeta> _checkMetaData(){
  //   List<BeerMeta>? metaList = beerMetaData[year];
  //   metaList ??= []; //if list is null initialise
  //   debugPrint("_checkMetaData metaList.length=${metaList.length} beers.length=${beers.length}");
  //   if(beers.length > metaList.length){
  //     var metaCreateCount = beers.length - metaList.length;
  //     final metas = List.generate(metaCreateCount, (index) {
  //       return BeerMeta(false);
  //     });
  //     List<BeerMeta> clone = List<BeerMeta>.of(metaList);
  //     clone.addAll(metas);
  //     return clone;
  //   }
  //   if(metaList.length > beers.length){
  //     throw Exception("metadata is longer than beers, wtf. year=$year metaList.length=${metaList.length} beers.length=${beers.length}");
  //   }
  //   return metaList;
  // }

  // void _createMetaData(List<StaticBeer> beers) {
  //   debugPrint("_createMetaData beerMetaData.length=${beerMetaData
  //       .length} beers.length=${beers.length}");
  //   if (beerMetaData.length < beers.length) {
  //     var metaCreateCount = beers.length - beerMetaData.length;
  //     final metas = List.generate(metaCreateCount, (index) {
  //       return BeerMeta(false);
  //     });
  //     List<BeerMeta> clone = List<BeerMeta>.of(beerMetaData);
  //     clone.addAll(metas);
  //     beerMetaData = clone;
  //   }
    // final m = List.generate(beers.length, (index) {
    //   // TODO may need to change when loading saved metadata
    //   return BeerMeta(false);
    // });
    // return m;
    // setState(() {
    // });
  // }


  // List<StaticBeer> _loadStaticBeers(String yearToLoad) {
  //   var sourceList = [];
  //   if (yearToLoad == "2023") {
  //     sourceList = beers2023;
  //   } else if (yearToLoad == "2022") {
  //     sourceList = beers2022;
  //   }
  //   final staticBeers = List.generate(sourceList.length, (index) {
  //     var beer = StaticBeer.fromJson(jsonDecode(sourceList[index]));
  //     return beer;
  //   });
  //   debugPrint("_loadStaticBeers found ${staticBeers.length} beers");
  //   return staticBeers;
  // }

  Future _loadSavedState() async {
    try {
      debugPrint("_loadSavedState starting");
      final prefs = await SharedPreferences.getInstance();
      debugPrint("_loadSavedState read from shared prefs");
      String json = prefs.getString("state") ?? '';
      debugPrint("_loadSavedState read json");
      if (json.isNotEmpty) {
        debugPrint("_loadSavedState about to convert json");
        SavedState savedState = SavedState.fromJson(jsonDecode(json));
        debugPrint("before festivalName");
        activeFestival = _getFestival(savedState.festivalName);
        // year = savedState.year;
        debugPrint("activeFestival=$activeFestival");
        debugPrint("before beerMetaList");
        beerMetaData = _loadMetaData(savedState.beerMetaByFestival);
        debugPrint("before searchText");
        searchText = savedState.searchText;
        debugPrint("before nameSearch");
        nameSearch = savedState.nameSearch;
        debugPrint("before notesSearch");
        notesSearch = savedState.notesSearch;
        debugPrint("before brewerySearch");
        brewerySearch = savedState.brewerySearch;
        debugPrint("before barSearch");
        barSearch = savedState.barSearch;
        debugPrint("before styleSearch");
        styleSearch = savedState.styleSearch;
        debugPrint("before countrySearch");
        countrySearch = savedState.countrySearch;
        debugPrint("before showHandpull");
        showHandpull = savedState.showHandpull;
        debugPrint("before showKeyKeg");
        showKeyKeg = savedState.showKeyKeg;
        debugPrint("before showBottles");
        showBottles = savedState.showBottles;
        debugPrint("before abvMin");
        abvMin = savedState.abvMin;
        debugPrint("before abvMax");
        abvMax = savedState.abvMax;
        debugPrint("before onlyShowWants");
        onlyShowWants = savedState.onlyShowWants;
        debugPrint("before onlyShowFavourites");
        onlyShowFavourites = savedState.onlyShowFavourites;
        debugPrint("before onlyShowTried");
        onlyShowTried = savedState.onlyShowTried;
        debugPrint("Saved state loaded");
        stateInitialised = true;
        // debugMeta();
      } else {
        debugPrint("Saved state not found");
      }
    } catch (e, s) {
      debugPrint("Error loading saved state");
      debugPrint(e.toString());
      debugPrint(s.toString());

      const snackBar = SnackBar(content: Text("Error loading saved state"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Map<String, List<BeerMeta>> _loadMetaData(Map<String, List<BeerMeta>> savedMeta){
    for(final festival in festivals){
      // first check that the key exists
      debugPrint("festival.name=${festival.name}");
      savedMeta.putIfAbsent(festival.name, () => []);
      // null check
      savedMeta[festival.name] ??= [];
      // count the diff
      var metaCreateCount = festival.staticBeers.length - savedMeta[festival.name]!.length;
      debugPrint("metaCreateCount=$metaCreateCount");
      if(metaCreateCount > 0){
        final extraMetas = List.generate(metaCreateCount, (index) {
          return BeerMeta(false);
        });
        savedMeta[festival.name]!.addAll(extraMetas);
      }
    }
    return savedMeta;
  }

  // debugMeta() {
  //   debugPrint("beerMetaData.length=${beerMetaData.length}");
  //   var triedIds = [];
  //   var ratingIds = [];
  //   for (var i = 0; i < beerMetaData.length; i++) {
  //     var element = beerMetaData[i];
  //     if (element.tried) {
  //       triedIds.add(i);
  //     }
  //     if (element.rating > 0) {
  //       ratingIds.add(i);
  //     }
  //   }
  //   debugPrint("triedIds=$triedIds");
  //   debugPrint("ratingIds=$ratingIds");
  // }
}