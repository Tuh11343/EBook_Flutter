import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../model/Favorite.dart';
import '../utils/APIProvider.dart';

class FavoriteAPI {
  Future<Response> findByUserID(int userID) async {
    try {
      Response response = await ApiProvider.getInstance()
          .get("/api/v1/favorite/userID", queryParameters: {"id": userID});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to find by user id: $e');
    }
  }

  Future<Response> findByBothID(int userID, int bookID) async {
    try {
      Response response = await ApiProvider.getInstance().get(
          "/api/v1/favorite/bothID",
          queryParameters: {"user_id": userID, "book_id": bookID});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to find favorite by both id: $e');
    }
  }

  Future<Response> favoriteClick(int userID, int bookID) async {
    try {
      Response response = await ApiProvider.getInstance().post(
          "/api/v1/favorite/favoriteClick",
          queryParameters: {"user_id": userID, "book_id": bookID});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to create account: $e');
    }
  }
}
