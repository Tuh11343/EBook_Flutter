import 'dart:ffi';

import 'package:ebook/api/PaymentAPI.dart';

class PaymentRepository {
  final PaymentAPI apiService = PaymentAPI();

  Future<dynamic> paymentRequest(int accountID,Float total) async {
    final response = await apiService.paymentRequest(accountID, total);
    return response;
  }

}
