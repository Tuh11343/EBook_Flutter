import 'package:ebook/app_instance.dart';
import 'package:ebook/model/Book.dart';
import 'package:ebook/model/SubscriptionHistory.dart';
import 'package:ebook/repository/AccountRepository.dart';
import 'package:ebook/repository/SubscriptionHistoryRepository.dart';
import 'package:ebook/repository/SubscriptionRepository.dart';
import 'package:ebook/repository/UserRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/Account.dart';
import '../model/Subscription.dart';
import '../model/User.dart' as model_user;
import 'package:shared_preferences/shared_preferences.dart';

class SignInController extends ChangeNotifier {
  final accountRepository = AccountRepository();
  final userRepository = UserRepository();
  final subscriptionRepository = SubscriptionRepository();
  final subscriptionHistoryRepository = SubscriptionHistoryRepository();

  bool isLoading = false;
  bool signInStatus = false;

  Future<bool> googleSignIn() async {
    signInStatus = false;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await GoogleSignIn()
          .signOut(); // Đăng xuất khỏi tài khoản Google hiện tại (nếu có)
      // await GoogleSignIn().disconnect(); // Ngắt kết nối tài khoản Google
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      //Tao tai khoan trong database neu lan dau dang nhap
      if (isNewUser) {
        model_user.User user = model_user.User(
            name: userCredential.user?.displayName ?? 'Không rõ',
            phone_number: userCredential.user?.phoneNumber);

        var userCreated = await userRepository.create(user);

        if (userCreated == null) {
          debugPrint('Loi tao nguoi dung');
          signInStatus = false;
        } else {
          SubscriptionHistory subscriptionHistory = SubscriptionHistory(
            name: 'Normal',
            price: 0.0,
            start: DateTime.now(),
            end: DateTime.now(),
          );
          var subscriptionHistoryCreated =
              await subscriptionHistoryRepository.create(subscriptionHistory);
          if (subscriptionHistoryCreated == null) {
            debugPrint('Loi tao subscription history');
            signInStatus = false;
          } else {
            Subscription subscription = Subscription(
                subscription_history_id: subscriptionHistoryCreated.id!,
                duration: 0.0.toDouble(),
                price_per_month: 0.0.toDouble(),
                type: 'Normal',
                limit_book_mark: 10,
                bookType: BookType.NORMAL);
            var subscriptionCreated =
                await subscriptionRepository.create(subscription);

            if (subscriptionCreated == null) {
              debugPrint('Loi tao subscription');
              signInStatus = false;
            } else {

              Account account = Account(
                  user_id: userCreated.id!,
                  subscription_id: subscriptionCreated.id!,
                  email: userCredential.user?.email ?? 'khong ro',
                  password: '123456',
                  is_verified: true);
              var accountCreated = await accountRepository.create(account);

              if (accountCreated != null) {
                debugPrint('Tao tai khoan thanh cong');
                signInStatus = true;
                var appInstance = AppInstance();
                await prefs.setInt(appInstance.accountID, accountCreated.id!);
              }
            }
          }
        }
      } else {
        Account? signInAccount =
            await accountRepository.findByEmail(userCredential.user!.email!);
        if (signInAccount == null) {
          debugPrint('Loi dang nhap');
        } else {
          var appInstance = AppInstance();
          await prefs.setInt(appInstance.accountID, signInAccount.id!);
          signInStatus = true;
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Loi dang nhap:${e.toString()}');
      notifyListeners();
    }
    return signInStatus;
  }

  Future<bool> signIn(String email, String password) async {
    signInStatus = false;
    isLoading = true;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var existedAccount = await accountRepository.signIn(email, password);
      if (existedAccount != null) {

        var accountSubscription =
            await subscriptionRepository.findByAccountID(existedAccount.id!);
        if (accountSubscription != null) {
          await prefs.setInt(AppInstance().accountID, existedAccount.id!);
          signInStatus = true;
        }
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      isLoading = false;
      notifyListeners();
    }
    return signInStatus;
  }
}
