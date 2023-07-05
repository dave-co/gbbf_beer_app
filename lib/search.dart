import 'package:flutter/material.dart';
import 'package:gbbf_beer_app/search_data.dart';
import 'package:gbbf_beer_app/util.dart';

class Search extends StatefulWidget {
  final String searchTextParam;
  final bool nameSearchParam;
  final bool notesSearchParam;
  final bool brewerySearchParam;
  final bool barSearchParam;
  final bool styleSearchParam;
  final bool countrySearchParam;

  final bool showHandpullParam;
  final bool showKeyKegParam;
  final bool showBottlesParam;

  final double abvMinParam;
  final double abvMaxParam;

  final bool onlyShowWantsParam;
  final bool onlyShowFavouritesParam;
  final bool onlyShowTriedParam;

  const Search(
      this.searchTextParam,
      this.nameSearchParam,
      this.notesSearchParam,
      this.brewerySearchParam,
      this.barSearchParam,
      this.styleSearchParam,
      this.countrySearchParam,
      this.showHandpullParam,
      this.showKeyKegParam,
      this.showBottlesParam,
      this.abvMinParam,
      this.abvMaxParam,
      this.onlyShowWantsParam,
      this.onlyShowFavouritesParam,
      this.onlyShowTriedParam,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateSearchState();
}

class _CreateSearchState extends State<Search> {
  // late String searchText;
  final searchTextController = TextEditingController();

  late bool nameSearch;
  late bool notesSearch;
  late bool brewerySearch;
  late bool barSearch;
  late bool styleSearch;
  late bool countrySearch;

  late bool showHandpull;
  late bool showKeyKeg;
  late bool showBottles;

  // late double abvMin;
  // late double abvMax;
  final int abvDivisions = 13;
  // final double maxAbv = 13;
  RangeValues abvRange = const RangeValues(4, 12);

  late bool onlyShowWants;
  late bool onlyShowFavourites;
  late bool onlyShowTried;

  @override
  void initState() {
    super.initState();
    searchTextController.text = widget.searchTextParam;
    nameSearch = widget.nameSearchParam;
    notesSearch = widget.notesSearchParam;
    brewerySearch = widget.brewerySearchParam;
    barSearch = widget.barSearchParam;
    styleSearch = widget.styleSearchParam;
    countrySearch = widget.countrySearchParam;
    showHandpull = widget.showHandpullParam;
    showKeyKeg = widget.showKeyKegParam;
    showBottles = widget.showBottlesParam;
    // abvMin = widget.abvMinParam;
    // abvMax = widget.abvMaxParam;
    abvRange = RangeValues(widget.abvMinParam, widget.abvMaxParam);

    onlyShowWants = widget.onlyShowWantsParam;
    onlyShowFavourites = widget.onlyShowFavouritesParam;
    onlyShowTried = widget.onlyShowTriedParam;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(
              context,
              SearchData(
                  searchTextController.text,
                  nameSearch,
                  notesSearch,
                  brewerySearch,
                  barSearch,
                  styleSearch,
                  countrySearch,
                  showHandpull,
                  showKeyKeg,
                  showBottles,
                  abvRange.start,
                  abvRange.end,
                  onlyShowWants,
                  onlyShowFavourites,
                  onlyShowTried));
          return false;
        },
        child: Scaffold(
            appBar: AppBar(title: const Text('Search')),
            body: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 8, left: 5, bottom: 5),
                          child: TextField(
                            controller: searchTextController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Search for...'),
                          ),
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding: const EdgeInsets.only(top: 6, left: 5, right: 8),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    searchTextController.text = '';
                                  });
                                },
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 36,
                                )
                            )
                        )
                    )
                  ],
                ),
                Row(
                    children :[
                      Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Name'),
                            value: nameSearch,
                            onChanged: (bool? value){
                              setState((){
                                nameSearch = !nameSearch;
                                // _search();
                              });
                            },
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Notes'),
                            value: notesSearch,
                            onChanged: (bool? value){
                              setState((){
                                notesSearch = !notesSearch;
                                // _search();
                              });
                            },
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Brewery'),
                            value: brewerySearch,
                            contentPadding: const EdgeInsets.all(5),
                            onChanged: (bool? value){
                              setState((){
                                brewerySearch = !brewerySearch;
                                // _search();
                              });
                            },
                          )
                      )
                    ]
                ),
                Row(
                    children :[
                      Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Bar'),
                            value: barSearch,
                            onChanged: (bool? value){
                              setState((){
                                barSearch = !barSearch;
                                // _search();
                              });
                            },
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Style'),
                            value: styleSearch,
                            onChanged: (bool? value){
                              setState((){
                                styleSearch = !styleSearch;
                                // _search();
                              });
                            },
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Country'),
                            value: countrySearch,
                            contentPadding: const EdgeInsets.all(5),
                            onChanged: (bool? value){
                              setState((){
                                countrySearch = !countrySearch;
                                // _search();
                              });
                            },
                          )
                      )
                    ]
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 17),
                      child: Text('ABV  ', textScaleFactor: 1.1),
                    ),
                    Text('${abvRange.start}'),
                    Expanded(child:
                    RangeSlider(
                        values: abvRange,
                        divisions: abvDivisions,
                        max: maxAbv,
                        onChanged: (RangeValues values) {
                          setState(() {
                            abvRange = values;
                            // _search();
                          });
                        }
                    )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text('${abvRange.end}${abvRange.end == maxAbv ? '+': ''}'),
                    )
                  ],
                ),
                Row(
                    children :[
                      Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Bottle'),
                            value: showBottles,
                            onChanged: (bool? value){
                              setState((){
                                showBottles = !showBottles;
                                // _search();
                              });
                            },
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Keykeg'),
                            value: showKeyKeg,
                            onChanged: (bool? value){
                              setState((){
                                showKeyKeg = !showKeyKeg;
                                // _search();
                              });
                            },
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Handpull'),
                            value: showHandpull,
                            contentPadding: const EdgeInsets.all(5),
                            onChanged: (bool? value){
                              setState((){
                                showHandpull = !showHandpull;
                                // _search();
                              });
                            },
                          )
                      )
                    ]
                ),
                Row(
                    children :[
                      Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Want'),
                            value: onlyShowWants,
                            onChanged: (bool? value){
                              setState((){
                                onlyShowWants = !onlyShowWants;
                                // _search();
                              });
                            },
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Tried'),
                            value: onlyShowTried,
                            onChanged: (bool? value){
                              setState((){
                                onlyShowTried = !onlyShowTried;
                                // _search();
                              });
                            },
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Favourite'),
                            value: onlyShowFavourites,
                            contentPadding: const EdgeInsets.all(5),
                            onChanged: (bool? value){
                              setState((){
                                onlyShowFavourites = !onlyShowFavourites;
                                // _search();
                              });
                            },
                          )
                      )
                    ]
                ),              ],
            )
        )
    );
  }
}
