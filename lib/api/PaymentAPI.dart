import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:ebook/utils/APIProvider.dart';

class PaymentAPI {
  Future<Response> paymentRequest(int accountID, double total) async {
    try {
      Response response = await ApiProvider.getInstance().post(
          "/api/v1/payment",
          queryParameters: {"accountID": accountID, "total": total});
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }
}
