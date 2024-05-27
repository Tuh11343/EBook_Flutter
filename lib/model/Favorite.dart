class Favorite {
  int? id;
  int book_id;
  int user_id;

  Favorite({this.id, required this.book_id, required this.user_id});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
        id: json['id'], book_id: json['book_id'], user_id: json['user_id']);
  }

  static bool getFavoriteAction(Map<String,dynamic> json){
    return json['action'] as bool;
  }
}
