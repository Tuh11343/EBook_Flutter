import 'package:dio/dio.dart';
import 'package:ebook/utils/APIProvider.dart';

class GenreAPI {
  Future<Response> findAll(int? limit, int? offset) async {
    try {
      Response response = await ApiProvider.getInstance().get("/api/v1/genre",
          queryParameters: {"limit": limit, "offset": offset});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findByID(int id) async {
    try {
      Response response = await ApiProvider.getInstance()
          .get("/api/v1/genre/id", queryParameters: {"id": id});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findByBookID(int bookID, int? limit, int? offset) async {
    try {
      Response response = await ApiProvider.getInstance().get(
          "/api/v1/genre/bookID",
          queryParameters: {"id": bookID, "limit": limit, "offset": offset});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }
}
