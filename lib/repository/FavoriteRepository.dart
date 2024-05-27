import 'package:ebook/model/Favorite.dart';

import '../api/FavoriteAPI.dart';

class FavoriteRepository {
  final FavoriteAPI apiService = FavoriteAPI();

  Future<bool> favoriteClick(int userID, int bookID) async {
    final response = await apiService.favoriteClick(userID, bookID);
    return Favorite.getFavoriteAction(response.data['action']);
  }
}
