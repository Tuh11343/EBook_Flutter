
class Book {
  int? id;
  String name;
  String? description;
  int rating;
  int progress;
  int published_year;
  String? image;
  String? language;
  BookType book_type;
  String? src_audio;
  String? lyric;

  Book({this.id,
    required this.name,
    this.description,
    required this.rating,
    required this.progress,
    required this.published_year,
    this.image,
    this.language,
    required this.book_type,
    this.src_audio,
    this.lyric});

  factory Book.fromJson(Map<String, dynamic> json){
    return Book(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      rating: json['rating'],
      progress: json['progress'],
      published_year: json['published_year'],
      image: json['image'],
      language: json['language'],
      book_type: json['book_type'] == 'NORMAL' ? BookType.NORMAL : BookType.PREMIUM,
      src_audio: json['src_audio'],
      lyric: json['lyric']
    );
  }
}

enum BookType { NORMAL, PREMIUM }
