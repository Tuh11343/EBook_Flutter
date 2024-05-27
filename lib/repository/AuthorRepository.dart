import 'package:ebook/model/Author.dart';

import '../api/AuthorAPI.dart';

class AuthorRepository {
  final AuthorAPI apiService = AuthorAPI();

  Future<List<Author>> findAll(int? limit, int? offset) async {
    final response = await apiService.findAll(limit, offset);
    List<dynamic> data = response.data['authors'];
    List<Author> authors = data.map((json) => Author.fromJson(json)).toList();
    return authors;
  }

  Future<List<Author>> findByBookID(
      int bookID, int? limit, int? offset) async {
    final response = await apiService.findByBookID(bookID, limit, offset);
    if (response.data['authors'] != null) {
      List<dynamic> data = response.data['authors'];
      List<Author> authors = data.map((json) => Author.fromJson(json)).toList();
      return authors;
    }
    return List.empty();
  }

  Future<String> findAuthorNameByBookID(int bookID) async {
    final response = await apiService.findOneByBookID(bookID);
    if (response.data['author'] != null) {
      return Author.getAuthorName(response.data['author']);
    }
    return '';
  }
}
