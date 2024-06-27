import 'package:dio/dio.dart';
import 'package:ebook/utils/APIProvider.dart';

import '../model/User.dart';

class UserAPI {
  Future<Response> findByID(int id) async {
    try {
      Response response = await ApiProvider.getInstance()
          .get("/api/v1/user/id", queryParameters: {"id": id});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findByAccountID(int accountID) async {
    try {
      Response response = await ApiProvider.getInstance()
          .get("/api/v1/user/accountID", queryParameters: {"id": accountID});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> createUser(User user) async {
    try {
      Response response =
          await ApiProvider.getInstance().post("/api/v1/user", data: user.toJson());
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }
}
