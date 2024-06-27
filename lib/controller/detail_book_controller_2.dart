

import 'package:flutter/material.dart';

import '../model/Author.dart';
import '../model/Book.dart';
import '../model/genre.dart';
import '../repository/AuthorRepository.dart';
import '../repository/BookRepository.dart';
import '../repository/FavoriteRepository.dart';
import '../repository/GenreRepository.dart';

class DetailBookController2 extends ChangeNotifier{

  final GenreRepository _genreRepository = GenreRepository();
  final AuthorRepository _authorRepository = AuthorRepository();
  final BookRepository _bookRepository = BookRepository();
  final FavoriteRepository _favoriteRepo = FavoriteRepository();

  bool isLoading = false;
  bool favoriteClickLoading = false;
  bool isFavorite=false;
  List<Genre> genreList = [];
  List<Author> authorList = [];
  List<List<Book>> authorBookList = [];

  Future<void> init(int userID,Book book) async {
    isFavorite=false;
    isLoading = true;
    notifyListeners();

    try {
      //Call API để lấy danh sách thể loại của sách
      var result = await _genreRepository.findByBookID(book.id!, null, null);
      genreList=result;


      //Call API để lấy danh sách tác giả của sách
      var result2 = await _authorRepository.findByBookID(book.id!, null, null);
      authorList=result2;

      //Call API để lấy danh sách sách của các tác giả
      if (authorList.isNotEmpty) {
        for (Author author in authorList) {
          var result3 = await _bookRepository.findByAuthorID(author.id!, 10, 0);
          authorBookList.add(result3);
        }
      }

      //Call API để check xem book có trong danh sách yêu thích
      var favorite=await _favoriteRepo.findByBothID(userID, book.id!);
      if(favorite!=null){
        isFavorite=true;
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error from init detail book:${e}');
      isLoading = false;
      notifyListeners();
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