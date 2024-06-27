import 'package:ebook/repository/BookRepository.dart';
import 'package:ebook/repository/GenreRepository.dart';
import 'package:ebook/response/load_more.dart';
import 'package:flutter/material.dart';

import '../model/genre.dart';

class FavoriteController extends ChangeNotifier {

  final bookRepo=BookRepository();

  bool isLoading=false;
  LoadMoreResponse bookList=LoadMoreResponse(bookList: [], maxLength: -1);

  Future<void> firstLoad(int userID,int? limit, int? offset) async {
    isLoading = true;
    notifyListeners();

    try {
      bookList=await bookRepo.findByFavorite(userID,5,0);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error from first load book:${e}');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore(int userID,int? limit, int? offset) async {
    isLoading=true;
    try {
      LoadMoreResponse result = await bookRepo.findByFavorite(userID,limit,offset);
      bookList.bookList.addAll(result.bookList);

      notifyListeners();
    } catch (e) {
      debugPrint('Error from loadMore book:${e}');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> favoriteListChanged(int userID,int? limit,int? offset)async{
    isLoading=true;
    notifyListeners();
    try{

      firstLoad(userID, limit, offset);
      isLoading=false;
      notifyListeners();

    }catch(e){
      isLoading=false;
      notifyListeners();
      debugPrint('Error from favorite list changed');
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

