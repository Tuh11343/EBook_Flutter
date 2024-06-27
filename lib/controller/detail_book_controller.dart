import 'package:ebook/repository/AuthorRepository.dart';
import 'package:ebook/repository/BookRepository.dart';
import 'package:ebook/repository/FavoriteRepository.dart';
import 'package:ebook/repository/GenreRepository.dart';
import 'package:flutter/material.dart';

import '../model/Author.dart';
import '../model/Book.dart';
import '../model/genre.dart';

class DetailBookController extends ChangeNotifier {
  final GenreRepository _genreRepository = GenreRepository();
  final AuthorRepository _authorRepository = AuthorRepository();
  final BookRepository _bookRepository = BookRepository();
  final FavoriteRepository _favoriteRepo = FavoriteRepository();

  bool _isLoading = false;
  bool favoriteClickLoading = false;
  bool isFavorite=false;
  List<List<Genre>> genreList = [];
  List<List<Author>?> authorList = [];
  List<List<List<Book>>> authorBookList = [];

  bool get isLoading => _isLoading;

  Future<void> init(int userID,Book book) async {
    isFavorite=false;
    _isLoading = true;
    notifyListeners();

    try {
      //Call API để lấy danh sách thể loại của sách
      var result = await _genreRepository.findByBookID(book.id!, null, null);
      genreList.add(result);

      //Call API để lấy danh sách tác giả của sách
      var result2 = await _authorRepository.findByBookID(book.id!, null, null);
      authorList.add(result2);

      //Call API để lấy danh sách sách của các tác giả
      if (authorList != null && authorList.last != null) {
        List<List<Book>> list = [];
        for (Author author in authorList.last!) {
          var result3 = await _bookRepository.findByAuthorID(author.id!, 10, 0);
          list.add(result3);
        }
        authorBookList.add(list);
      }

      //Call API để check xem book có trong danh sách yêu thích
      var favorite=await _favoriteRepo.findByBothID(userID, book.id!);
      if(favorite!=null){
        isFavorite=true;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error from init detail book:${e}');
      _isLoading = false;
      notifyListeners();
    }
  }

  void backPressEvent() {
    try {
      genreList.removeLast();
      authorList.removeLast();
      authorBookList.removeLast();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> favoriteClick(int userID, int bookID) async {
    favoriteClickLoading = true;
    notifyListeners();
    try {
      var result = await _favoriteRepo.favoriteClick(userID, bookID);
      isFavorite=result;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error from add to favorite:${e}');
      favoriteClickLoading = false;
      notifyListeners();
    }
    return false;
  }
  
}
