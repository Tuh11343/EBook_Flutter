import 'package:ebook/api/SubscriptionAPI.dart';
import 'package:ebook/model/Subscription.dart';

class SubscriptionRepository {
  final SubscriptionAPI apiService = SubscriptionAPI();

  Future<Subscription?> create(Subscription subscription) async {
    final response = await apiService.create(subscription);
    if (response.data['subscription'] != null) {
      return Subscription.fromJson(response.data['subscription']);
    }
    return null;
  }

  Future<Subscription?> update(Subscription subscription) async {
    final response = await apiService.update(subscription);
    if (response.data['subscription'] != null) {
      return Subscription.fromJson(response.data['subscription']);
    }
    return null;
  }

  Future<Subscription?> findByAccountID(int accountID) async {
    final response = await apiService.findByAccountID(accountID);
    if (response.data['subscription'] != null) {
      return Subscription.fromJson(response.data['subscription']);
    }
    return null;
  }
}
