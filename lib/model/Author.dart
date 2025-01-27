class Author{
  int? id;
  String name;
  String image;
  String? description;

  Author({this.id,required this.name,required this.image,this.description});
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
    );
  }

  static String getAuthorName(Map<String,dynamic> json){
    return json['author'] as String;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'image': image,
      'description':description
    };
  }
}