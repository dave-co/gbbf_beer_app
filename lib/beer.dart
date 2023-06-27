class Beer {
  int id;
  String name;
  double abv;
  String style;
  String barCode;
  String notes;
  String brewery;
  String country;
  String untappdUrl;
  String dispenseMethod;

  Beer(this.id, this.name, this.abv, this.style, this.barCode, this.notes,
      this.brewery, this.country, this.untappdUrl, this.dispenseMethod);

  factory Beer.fromJson(dynamic json) {
    return Beer(json['id'] as int,
        json['name'] as String,
        double.parse(json['abv'] as String),
        json['style'] as String,
        json['barCode'] as String,
        json['notes'] as String,
        json['brewery'] as String,
        json['country'] as String,
        json['untappdUrl'] == null ? '' : json['untappdUrl'] as String,
        json['dispenseMethod'] == null ? 'unknown' : json['dispenseMethod'] as String);
  }
}