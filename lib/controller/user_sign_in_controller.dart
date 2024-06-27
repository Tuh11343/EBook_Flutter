import 'package:ebook/app_instance.dart';
import 'package:ebook/repository/AccountRepository.dart';
import 'package:ebook/repository/SubscriptionHistoryRepository.dart';
import 'package:ebook/repository/SubscriptionRepository.dart';
import 'package:ebook/repository/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';

class UserSignInController extends ChangeNotifier {
  final accountRepository = AccountRepository();
  final userRepository = UserRepository();
  final subscriptionRepository = SubscriptionRepository();
  final subscriptionHistoryRepository = SubscriptionHistoryRepository();

  bool isLoading = false;
  String userName='';

  Future<void> getUserName(int accountID) async {
    isLoading = true;
    notifyListeners();

    try {
      User? user=await userRepository.findByAccountID(accountID);
      if(user!=null){
        userName=user.name;
      }else{
        userName='Không rõ';
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      isLoading = false;
      notifyListeners();
    }
  }
}
