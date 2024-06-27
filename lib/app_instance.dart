

import 'model/Account.dart';
import 'model/Subscription.dart';

class AppInstance {
  static final AppInstance _instance = AppInstance._internal();

  /*Account? currentAccount;
  Subscription? currentSubscription;*/
  String accountID='ACCOUNT_ID';


  factory AppInstance() {
    return _instance;
  }



  AppInstance._internal();
}