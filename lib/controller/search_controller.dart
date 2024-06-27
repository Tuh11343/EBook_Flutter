import 'package:ebook/repository/BookRepository.dart';
import 'package:ebook/repository/GenreRepository.dart';
import 'package:ebook/response/load_more.dart';
import 'package:flutter/material.dart';

import '../model/genre.dart';

class SearchViewController extends ChangeNotifier {
  final BookRepository _bookRepository = BookRepository();
  final GenreRepository _genreRepository = GenreRepository();

  LoadMoreResponse bookList = LoadMoreResponse(bookList: [], maxLength: -1);
  LoadMoreResponse loadMoreBookList =
      LoadMoreResponse(bookList: [], maxLength: -1);
  List<Genre> genreList = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> firstLoad(
      String name, int? genreID, int? limit, int? offset) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (genreID == null) {
        bookList = await _bookRepository.findByName(name, limit, offset);
      } else {
        bookList = await _bookRepository.findByNameAndGenre(
            name, genreID, limit, offset);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore(
      String name, int? genreID, int? limit, int? offset) async {
    try {
      if (genreID == null) {
        LoadMoreResponse result =
            await _bookRepository.findByName(name, limit, offset);
        bookList.bookList.addAll(result.bookList);
      } else {
        LoadMoreResponse result = await _bookRepository.findByNameAndGenre(
            name, genreID, limit, offset);
        bookList.bookList.addAll(result.bookList);
      }

      debugPrint('So luong sach hien tai:${bookList.bookList.length}');
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadGenreList() async {
    _isLoading = true;
    notifyListeners();

    try {
      genreList = await _genreRepository.findAll(null, null);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void sortList(String? sortOption) {
    if (sortOption == null) {
      bookList.bookList.sort(
        (a, b) {
          return a.id!.compareTo(b.id!);
        },
      );
    } else if (sortOption == 'Tên sách') {
      bookList.bookList.sort(
        (a, b) {
          return a.name!.compareTo(b.name!);
        },
      );
    } else if (sortOption == 'Đánh giá') {
      bookList.bookList.sort(
        (a, b) {
          return a.rating!.compareTo(b.rating!);
        },
      );
    }
    notifyListeners();
  }
}
