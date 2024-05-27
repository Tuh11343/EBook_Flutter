import 'package:dio/dio.dart';

import '../utils/APIProvider.dart';

class AuthorAPI {
  Future<Response> findAll(int? limit, int? offset) async {
    try {
      Response response = await ApiProvider.getInstance().get("/api/v1/author",
          queryParameters: {"limit": limit, "offset": offset});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findByBookID(int bookID, int? limit, int? offset) async {
    try {
      Response response = await ApiProvider.getInstance().get(
          "/api/v1/author/bookID",
          queryParameters: {"id": bookID, "limit": limit, "offset": offset});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findOneByBookID(int bookID) async {
    try {
      Response response = await ApiProvider.getInstance()
          .get("/api/v1/author/bookAuthorOne", queryParameters: {"id": bookID});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }
}
