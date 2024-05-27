import 'package:ebook/api/SubscriptionHistoryAPI.dart';
import 'package:ebook/model/SubscriptionHistory.dart';

class SubscriptionHistoryRepository {
  final SubscriptionHistoryAPI apiService = SubscriptionHistoryAPI();

  Future<SubscriptionHistory?> create(
      SubscriptionHistory subscriptionHistory) async {
    final response = await apiService.create(subscriptionHistory);
    if (response.data['subscriptionHistory'] != null) {
      return SubscriptionHistory.fromJson(response.data['subscriptionHistory']);
    }
    return null;
  }

  Future<SubscriptionHistory?> update(
      SubscriptionHistory subscriptionHistory) async {
    final response = await apiService.update(subscriptionHistory);
    if (response.data['subscriptionHistory'] != null) {
      return SubscriptionHistory.fromJson(response.data['subscriptionHistory']);
    }
    return null;
  }

  Future<SubscriptionHistory?> findBySubscriptionID(int subscriptionID) async {
    final response = await apiService.findBySubscriptionID(subscriptionID);
    if (response.data['subscriptionHistory'] != null) {
      return SubscriptionHistory.fromJson(response.data['subscriptionHistory']);
    }
    return null;
  }
}
