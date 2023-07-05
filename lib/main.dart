import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gbbf_beer_app/beer.dart';
import 'package:gbbf_beer_app/search_data.dart';
import 'package:gbbf_beer_app/settings.dart';
import 'package:gbbf_beer_app/search.dart';
import 'package:gbbf_beer_app/saved_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gbbf_beer_app/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'beer_lists.dart';
import 'beer_meta.dart';

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

  List<Beer> beers = [];
  var filteredBeers = [];
  List<BeerMeta> beerMetaData = [];
  int _counter = 0;
  String year = "2023";
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

  @override
  void initState(){
    super.initState();
    _loadSavedState()
        .then((_) {
          beers = _loadStaticBeers(year);
          beerMetaData = _createMetaData(beers);
        });
  }

  void _incrementCounter(){
    setState(() {
      _counter++;
    });
  }

  void _settingsResult(newYear){
    debugPrint("returned from settings");
    setState(() {
      year = newYear;
    });
  }

  void _searchFieldsResult(SearchData searchData){
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
  }

  void _searchBeers(){
    setState((){
      filteredBeers = beers.where((beer) {
        // check abv first, if outside the range we don't care about the rest of the search options
        if(beer.abv < abvMin || (abvMax != maxAbv && beer.abv > abvMax)){
          return false;
        }
        // now check dispense method
        if(beer.dispenseMethod == "Handpull" && !showHandpull || beer.dispenseMethod == "KeyKeg" && !showKeyKeg || beer.dispenseMethod == "Bottle" && !showBottles){
          return false;
        }
        BeerMeta beerMeta = beerMetaData[beer.id];
        if(onlyShowTried == true && !beerMeta.tried){return false;}
        if(onlyShowWants == true && !beerMeta.want){return false;}
        if(onlyShowFavourites == true && !beerMeta.favourite){return false;}

        String text = searchText.toLowerCase();
        if(nameSearch    && beer.name.toLowerCase().contains(text)){return true;}
        if(notesSearch   && beer.notes.toLowerCase().contains(text)){return true;}
        if(brewerySearch && beer.brewery.toLowerCase().contains(text)){return true;}
        if(barSearch     && beer.barCode.toLowerCase().contains(text)){return true;}
        if(styleSearch   && beer.style.toLowerCase().contains(text)){return true;}
        if(countrySearch && beer.country.toLowerCase().contains(text)){return true;}

        if(!nameSearch && !notesSearch && !brewerySearch && !barSearch && !styleSearch && !countrySearch){
          return true;
        }
        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    useEffect(() {
      _saveState();
      _searchBeers();
      return (){};
    },[searchText, nameSearch, notesSearch, brewerySearch, barSearch,
      styleSearch, countrySearch, showHandpull, showKeyKeg, showBottles,
      abvMin, abvMax, onlyShowWants, onlyShowFavourites, onlyShowTried]);

    useEffect(() {
      _loadStaticBeers(year);
      _saveState();
      _searchBeers();
      return (){};
    },[year]);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Gbbf Beers $year'),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Search(
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
                            builder: (context) => Settings(year)))
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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _saveState() async {
    debugPrint("saving state");
    final prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(SavedState(year
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
    ));
    prefs.setString("state", json);
  }

  List<BeerMeta> _createMetaData(List<Beer> beers) {
    final m = List.generate(beers.length, (index) {
      // TODO may need to change when loading saved metadata
      return BeerMeta(false);
    });
    return m;
    // setState(() {
    // });
  }


  List<Beer> _loadStaticBeers(String yearToLoad) {
    var sourceList = [];
    if(yearToLoad == "2023"){
      sourceList = beers2023;
    } else if (yearToLoad == "2022"){
      sourceList = beers2022;
    }
    final staticBeers = List.generate(sourceList.length, (index) {
      var beer = Beer.fromJson(jsonDecode(sourceList[index]));
      return beer;
    });
    debugPrint("found ${staticBeers.length} beers");
    return staticBeers;
  }

  Future _loadSavedState() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      String json = prefs.getString("state") ?? '';
      if(json.isNotEmpty){
        SavedState savedState = SavedState.fromJson(jsonDecode(json));
        debugPrint("before year");
        year = savedState.year;
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
      } else {
        debugPrint("Saved state not found");
      }
    } catch(e){
      debugPrint("Error loading saved state");
      debugPrint(e.toString());

      const snackBar = SnackBar(content: Text("Error loading saved state"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}