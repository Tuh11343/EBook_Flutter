import 'package:ebook/api/GenreAPI.dart';
import 'package:ebook/model/genre.dart';

class GenreRepository {
  final GenreAPI apiService = GenreAPI();

  Future<List<Genre>> findAll(int? limit, int? offset) async {
    final response = await apiService.findAll(limit, offset);
    List<dynamic> data = response.data['genres'];
    List<Genre> genres = data.map((json) => Genre.fromJson(json)).toList();
    return genres;
  }

  Future<List<Genre>> findByBookID(int bookID, int? limit, int? offset) async {
    final response = await apiService.findByBookID(bookID, limit, offset);
    if (response.data['genres'] != null) {
      List<dynamic> data = response.data['genres'];
      List<Genre> genres = data.map((json) => Genre.fromJson(json)).toList();
      return genres;
    }
    return List.empty();
  }
}
