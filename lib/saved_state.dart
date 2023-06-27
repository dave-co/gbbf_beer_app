class SavedState{
  String year;

  SavedState(this.year);

  Map toJson(){
    return {
      "year" : year
    };
  }
  factory SavedState.fromJson(dynamic json){
    return SavedState(
        json['year'] as String
    );
  }
}