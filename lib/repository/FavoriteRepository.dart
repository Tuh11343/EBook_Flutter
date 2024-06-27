import 'package:ebook/model/Favorite.dart';
import 'package:flutter/cupertino.dart';

import '../api/FavoriteAPI.dart';

class FavoriteRepository {
  final FavoriteAPI apiService = FavoriteAPI();

  Future<bool> favoriteClick(int userID, int bookID) async {
    final response = await apiService.favoriteClick(userID, bookID);
    return response.data['action'] as bool;
  }


  Future<Favorite?> findByBothID(int userID,int bookID) async {
    final response = await apiService.findByBothID(userID, bookID);
    if (response.data['favorite'] != null) {
      return Favorite.fromJson(response.data['favorite']);
    }
    return null;
  }
}
