import 'dart:convert';

import 'package:ebook/model/Book.dart';
import 'package:ebook/model/SubscriptionHistory.dart';
import 'package:ebook/repository/PaymentRepository.dart';
import 'package:ebook/repository/SubscriptionHistoryRepository.dart';
import 'package:ebook/repository/SubscriptionRepository.dart';
import 'package:flutter/cupertino.dart';

import '../model/Subscription.dart';

class PaymentController extends ChangeNotifier {
  PaymentRepository paymentRepository = PaymentRepository();
  SubscriptionRepository subscriptionRepository = SubscriptionRepository();
  SubscriptionHistoryRepository subscriptionHistoryRepository =
      SubscriptionHistoryRepository();

  bool isReadyToPayment = false;
  bool errorPayment = false;

  Future<dynamic> paymentRequest(int accountID, double total) async {
    isReadyToPayment = false;
    errorPayment = false;
    notifyListeners();
    try {
      var result = await paymentRepository.paymentRequest(accountID, total);
      isReadyToPayment = true;
      return result;
    } catch (e) {
      debugPrint('Payment Request Error:${e}');
      isReadyToPayment = false;
      errorPayment = true;
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateAccountToPremium(Subscription subscription,
      SubscriptionHistory subscriptionHistory) async {
    bool result = false;

    try {
      subscription.bookType = BookType.PREMIUM;
      subscription.duration = 30;
      subscription.limit_book_mark = -1;
      subscription.price_per_month = 200;
      subscription.type = 'Premium';
      var updatedSubscription =
          await subscriptionRepository.update(subscription);
      if (updatedSubscription != null) {
        subscriptionHistory.start = DateTime.now();
        subscriptionHistory.end = DateTime.now().add(const Duration(days: 30));
        subscriptionHistory.price = 200;
        subscriptionHistory.name = 'Premium';
        var updatedSubscriptionHistory =
            await subscriptionHistoryRepository.update(subscriptionHistory);
        if (updatedSubscriptionHistory != null) {
          result = true;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint(
          'Error from update subscription and subscription history after payment');
      result = false;
      notifyListeners();
    }
    return result;
  }

  Future<bool> updateAccountToNormal(Subscription subscription,
      SubscriptionHistory subscriptionHistory) async {
    bool result = false;

    try {
      subscription.bookType = BookType.NORMAL;
      subscription.duration = 0;
      subscription.limit_book_mark = 10;
      subscription.price_per_month = 0;
      subscription.type = 'Normal';
      var updatedSubscription =
          await subscriptionRepository.update(subscription);
      if (updatedSubscription != null) {
        subscriptionHistory.start = DateTime.now();
        subscriptionHistory.end = DateTime.now();
        subscriptionHistory.price = 0;
        subscriptionHistory.name = 'Normal';
        var updatedSubscriptionHistory =
            await subscriptionHistoryRepository.update(subscriptionHistory);
        if (updatedSubscriptionHistory != null) {
          result = true;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint(
          'Error from update subscription and subscription history after payment');
      result = false;
      notifyListeners();
    }
    return result;
  }
}
