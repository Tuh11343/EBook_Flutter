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

class SignUpController extends ChangeNotifier {
  final accountRepository = AccountRepository();
  final userRepository = UserRepository();
  final subscriptionRepository = SubscriptionRepository();
  final subscriptionHistoryRepository = SubscriptionHistoryRepository();

  bool isLoading = false;
  bool signUpStatus = false;
  bool existedGmail = false;

  Future<bool> googleSignUp() async {
    signUpStatus = false;
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
          signUpStatus = false;
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
            signUpStatus = false;
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
              signUpStatus = false;
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
                signUpStatus = true;
                await prefs.setInt(AppInstance().accountID, accountCreated.id!);
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
          signUpStatus = true;
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Loi dang nhap:${e.toString()}');
      notifyListeners();
    }
    return signUpStatus;
  }

  Future<bool> signUp(String email, String password, String userName) async {
    signUpStatus = false;
    isLoading = true;
    existedGmail = false;
    notifyListeners();

    try {
      var existedAccount = await accountRepository.signIn(email, password);
      if (existedAccount != null) {
        signUpStatus = false;
        existedGmail = true;
      } else {
        model_user.User user = model_user.User(name: userName);

        var userCreated = await userRepository.create(user);

        if (userCreated == null) {
          debugPrint('Loi tao nguoi dung');
          signUpStatus = false;
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
            signUpStatus = false;
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
              signUpStatus = false;
            } else {
              Account account = Account(
                  user_id: userCreated.id!,
                  subscription_id: subscriptionCreated.id!,
                  email: email,
                  password: password,
                  is_verified: true);
              var accountCreated = await accountRepository.create(account);

              if (accountCreated != null) {
                debugPrint('Tao tai khoan thanh cong');
                signUpStatus = true;
              }
            }
          }
        }
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      isLoading = false;
      notifyListeners();
    }
    return signUpStatus;
  }
}
