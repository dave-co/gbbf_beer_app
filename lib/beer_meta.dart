class BeerMeta {
  bool showDetail;
  bool want = false;
  bool tried = false;
  bool favourite = false;
  int rating = 0;

  BeerMeta(this.showDetail);

  BeerMeta.all(this.showDetail, this.want, this.tried, this.favourite, this.rating);

  void set(String propertyName, dynamic value){
    switch(propertyName) {
      case 'showDetail':
        showDetail = value;
        break;
      case 'want':
        want = value;
        break;
      case 'tried':
        tried = value;
        break;
      case 'favourite':
        favourite = value;
        break;
      case 'rating':
        rating = value;
    }
  }

  Map toJson() => {
    "showDetail" : showDetail,
    "want" : want,
    "tried" : tried,
    "favourite" : favourite,
    "rating" : rating
  };

  factory BeerMeta.fromJson(json) {
    return BeerMeta.all(
        json["showDetail"] as bool,
        json["want"] as bool,
        json["tried"] as bool,
        json["favourite"] as bool,
        json["rating"] as int
    );
  }
}