import 'package:dio/dio.dart';
import 'package:ebook/model/Subscription.dart';
import 'package:ebook/utils/APIProvider.dart';

class SubscriptionAPI {
  Future<Response> findByAccountID(int accountID) async {
    try {
      Response response = await ApiProvider.getInstance()
          .get("/api/v1/subscription/accountID", queryParameters: {"id": accountID});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> create(Subscription subscription) async {
    try {
      Response response = await ApiProvider.getInstance()
          .post("/api/v1/subscription", data: subscription.toJson());
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> update(Subscription subscription) async {
    try {
      Response response = await ApiProvider.getInstance()
          .put("/api/v1/subscription", data: subscription.toJson());
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }
}
