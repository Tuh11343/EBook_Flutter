import 'package:dio/dio.dart';
import 'package:ebook/model/Subscription.dart';
import 'package:ebook/utils/APIProvider.dart';

import '../model/SubscriptionHistory.dart';

class SubscriptionHistoryAPI {
  Future<Response> findByID(int id) async {
    try {
      Response response = await ApiProvider.getInstance()
          .get("/api/v1/subscriptionHistory", queryParameters: {"id": id});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> findBySubscriptionID(int subscriptionID) async {
    try {
      Response response = await ApiProvider.getInstance().get(
          "/api/v1/subscriptionHistory/subscriptionID",
          queryParameters: {"id": subscriptionID});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> create(SubscriptionHistory subscriptionHistory) async {
    try {
      Response response = await ApiProvider.getInstance()
          .post("/api/v1/subscriptionHistory", data: subscriptionHistory);
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> update(SubscriptionHistory subscriptionHistory) async {
    try {
      Response response = await ApiProvider.getInstance()
          .put("/api/v1/subscriptionHistory", data: subscriptionHistory);
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }
}
