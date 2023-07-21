import 'package:gbbf_beer_app/static_beer.dart';

import 'beer_meta.dart';

class Festival {
  String name;
  // String viewName;
  List<StaticBeer> staticBeers;
  // List<BeerMeta>? beerMeta;

  Festival(
      this.name
      // ,this.viewName
      ,this.staticBeers);

  // Festival.fromFestival(Festival another):
  //   name = another.name,
  //   staticBeers = another.staticBeers,
  //   beerMeta = another.beerMeta;

}