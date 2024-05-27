import 'package:ebook/repository/AuthorRepository.dart';
import 'package:ebook/repository/BookRepository.dart';
import 'package:ebook/repository/GenreRepository.dart';
import 'package:flutter/material.dart';

import '../model/Author.dart';
import '../model/Book.dart';
import '../model/genre.dart';

class DetailBookController extends ChangeNotifier {
  final GenreRepository _genreRepository = GenreRepository();
  final AuthorRepository _authorRepository = AuthorRepository();
  final BookRepository _bookRepository = BookRepository();


  bool _isLoading = false;
  List<List<Genre>> _genreList = [];
  List<List<Author>> _authorList = [];
  List<List<List<Book>>> _authorBookList = [];

  bool get isLoading => _isLoading;

  Future<void> init(Book book) async {
    _isLoading = true;
    notifyListeners();

    try {
      //Call API để lấy danh sách thể loại của sách
      var result = await _genreRepository.findByBookID(book.id!, null, null);
      _genreList.add(result);

      //Call API để lấy danh sách tác giả của sách
      var result2 = await _authorRepository.findByBookID(book.id!, null, null);
      _authorList.add(result2);

      //Call API để lấy danh sách sách của các tác giả
      if (_authorList != null && _authorList.last != null) {
        List<List<Book>> list = [];
        for (Author author in _authorList.last!) {
          var result3 = await _bookRepository.findByAuthorID(author.id!, 10, 0);
          list.add(result3);
        }
        _authorBookList.add(list);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void backPressEvent() {
    try {
      _genreList.removeLast();
      _authorList.removeLast();
      _authorBookList.removeLast();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<List<Genre>> get genreList => _genreList;

  List<List<Author>> get authorList => _authorList;

  List<List<List<Book>>> get authorBookList => _authorBookList;
}
