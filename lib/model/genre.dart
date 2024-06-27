
class Genre {
  int? id;
  String name;
  String? image;

  Genre({this.id, required this.name,this.image});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
      image: json['image']
    );
  }
}