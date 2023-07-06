import 'package:flutter/material.dart';
import 'package:gbbf_beer_app/labelled_checkbox.dart';
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
          // resizeToAvoidBottomInset: false,
            appBar: AppBar(title: const Text('Search')),
            body: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black38,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                            children:[
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
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 17),
                                    child: Text(
                                      "Search in:",
                                      textAlign: TextAlign.left,
                                      textScaleFactor: 1,)
                                )
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: LabelledCheckbox(
                                        text: const Text('Name', textScaleFactor: 1.1,),
                                        padding: const EdgeInsets.only(left: 1),
                                        value: nameSearch,
                                        onChanged: (bool? value){
                                          setState((){
                                            nameSearch = !nameSearch;
                                          });
                                        })
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: LabelledCheckbox(
                                          text: const Text('Notes', textScaleFactor: 1.1,),
                                          padding: const EdgeInsets.only(left: 1),
                                          value: notesSearch,
                                          onChanged: (bool? value){
                                            setState((){
                                              notesSearch = !notesSearch;
                                            });
                                          })
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: LabelledCheckbox(
                                          text: const Text('Brewery', textScaleFactor: 1.1,),
                                          padding: const EdgeInsets.only(left: 1),
                                          value: brewerySearch,
                                          onChanged: (bool? value){
                                            setState((){
                                              brewerySearch = !brewerySearch;
                                            });
                                          })
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: LabelledCheckbox(
                                          text: const Text('Bar', textScaleFactor: 1.1,),
                                          padding: const EdgeInsets.only(left: 1),
                                          value: barSearch,
                                          onChanged: (bool? value){
                                            setState((){
                                              barSearch = !barSearch;
                                            });
                                          })
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: LabelledCheckbox(
                                          text: const Text('Style', textScaleFactor: 1.1,),
                                          padding: const EdgeInsets.only(left: 1),
                                          value: styleSearch,
                                          onChanged: (bool? value){
                                            setState((){
                                              styleSearch = !styleSearch;
                                            });
                                          })
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: LabelledCheckbox(
                                          text: const Text('Country', textScaleFactor: 1.1,),
                                          padding: const EdgeInsets.only(left: 1),
                                          value: countrySearch,
                                          onChanged: (bool? value){
                                            setState((){
                                              countrySearch = !countrySearch;
                                            });
                                          })
                                  ),
                                ],
                              ),
                            ]
                        )
                    ),
                    Card(
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black38,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 17, top: 5),
                                    child: Text(
                                      "Limit results to:",
                                      textAlign: TextAlign.left,
                                      textScaleFactor: 1,)
                                )
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
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: LabelledCheckbox(
                                        text: const Text('Bottles', textScaleFactor: 1.1,),
                                        padding: const EdgeInsets.only(left: 1),
                                        value: showBottles,
                                        onChanged: (bool? value){
                                          setState((){
                                            showBottles = !showBottles;
                                          });
                                        })
                                ),
                                Expanded(
                                    flex: 2,
                                    child: LabelledCheckbox(
                                        text: const Text('Keykeg', textScaleFactor: 1.1,),
                                        padding: const EdgeInsets.only(left: 1),
                                        value: showKeyKeg,
                                        onChanged: (bool? value){
                                          setState((){
                                            showKeyKeg = !showKeyKeg;
                                          });
                                        })
                                ),
                                Expanded(
                                    flex: 2,
                                    child: LabelledCheckbox(
                                        text: const Text('Handpull', textScaleFactor: 1.1,),
                                        padding: const EdgeInsets.only(left: 1),
                                        value: showHandpull,
                                        onChanged: (bool? value){
                                          setState((){
                                            showHandpull = !showHandpull;
                                          });
                                        })
                                ),
                              ],
                            ),
                        ],)
                    ),
                    Card(
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black38,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                            children:[
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 17, top: 5),
                                      child: Text(
                                        "Show only:",
                                        textAlign: TextAlign.left,
                                        textScaleFactor: 1,)
                                  )
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: LabelledCheckbox(
                                          text: const Text('Want', textScaleFactor: 1.1,),
                                          padding: const EdgeInsets.only(left: 1),
                                          value: onlyShowWants,
                                          onChanged: (bool? value){
                                            setState((){
                                              onlyShowWants = !onlyShowWants;
                                            });
                                          })
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: LabelledCheckbox(
                                          text: const Text('Tried', textScaleFactor: 1.1,),
                                          padding: const EdgeInsets.only(left: 1),
                                          value: onlyShowTried,
                                          onChanged: (bool? value){
                                            setState((){
                                              onlyShowTried = !onlyShowTried;
                                            });
                                          })
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: LabelledCheckbox(
                                          text: const Text('Favourite', textScaleFactor: 1.1,),
                                          padding: const EdgeInsets.only(left: 1),
                                          value: onlyShowFavourites,
                                          onChanged: (bool? value){
                                            setState((){
                                              onlyShowFavourites = !onlyShowFavourites;
                                            });
                                          })
                                  ),
                                ],
                              ),
                          ]
                        )
                    ),

                  ],
            )
            )
        )
    );
  }
}
