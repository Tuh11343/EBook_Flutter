import 'package:dio/dio.dart';

import '../utils/APIProvider.dart';

class BookAPI {
  Future<Response> findAll(int? limit, int? offset) async {
    try {
      Response response = await ApiProvider.getInstance().get("/api/v1/book",
          queryParameters: {"limit": limit, "offset": offset});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findByAuthorID(int authorID, int? limit, int? offset) async {
    try {
      Response response = await ApiProvider.getInstance().get(
          "/api/v1/book/author",
          queryParameters: {"id": authorID, "limit": limit, "offset": offset});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findNormal(int? limit, int? offset) async {
    try {
      Response response = await ApiProvider.getInstance().get(
          "/api/v1/book/normal",
          queryParameters: {"limit": limit, "offset": offset});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findPremium(int? limit, int? offset) async {
    try {
      Response response = await ApiProvider.getInstance().get(
          "/api/v1/book/premium",
          queryParameters: {"limit": limit, "offset": offset});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findByFavorite(int id) async {
    try {
      Response response = await ApiProvider.getInstance().get(
        "/api/v1/book/favorite",
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findByNameAndGenre(String name,int genreID,int? limit, int? offset) async {
    try {
      Response response = await ApiProvider.getInstance().get("/api/v1/book/nameAndGenre",
          queryParameters: {"name":name,"genre_id":genreID,"limit": limit, "offset": offset});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findByName(String name,int? limit, int? offset) async {
    try {
      Response response = await ApiProvider.getInstance().get("/api/v1/book/name",
          queryParameters: {"name":name,"limit": limit, "offset": offset});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findByTopRating(int? limit, int? offset) async {
    try {
      Response response = await ApiProvider.getInstance().get("/api/v1/book/topRating",
          queryParameters: {"limit": limit, "offset": offset});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }
}
