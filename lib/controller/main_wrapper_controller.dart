import 'package:ebook/model/Subscription.dart';
import 'package:ebook/repository/AccountRepository.dart';
import 'package:ebook/repository/AuthorRepository.dart';
import 'package:ebook/repository/BookRepository.dart';
import 'package:ebook/repository/GenreRepository.dart';
import 'package:ebook/repository/SubscriptionHistoryRepository.dart';
import 'package:ebook/repository/SubscriptionRepository.dart';
import 'package:ebook/repository/UserRepository.dart';
import 'package:flutter/material.dart';

import '../model/Account.dart';
import '../model/Author.dart';
import '../model/Book.dart';
import '../model/SubscriptionHistory.dart';
import '../model/User.dart';
import '../model/genre.dart';

class MainWrapperController extends ChangeNotifier {

  final _accountRepository=AccountRepository();
  final _subscriptionRepository=SubscriptionRepository();
  final _subscriptionHistoryRepository=SubscriptionHistoryRepository();
  final _userRepo=UserRepository();

  bool songControlVisibility=false;
  bool bottomNavigationVisibility=true;
  bool accountLoading=false;

  Account? currentAccount;
  User? currentUser;
  Subscription? currentAccountSubscription;
  SubscriptionHistory? accountSubscriptionHistory;

  void updateSongControlVisibility(bool show){
    songControlVisibility=show;
    notifyListeners();
  }

  void updateBottomNavigationVisibility(bool show){
    bottomNavigationVisibility=show;
    notifyListeners();
  }

  Future<void> findAccountByID(int id) async {
    accountLoading=true;
    notifyListeners();

    try{

      currentAccount=await _accountRepository.findByID(id);
      if(currentAccount!=null&&currentAccount!.id!=null){
        currentAccountSubscription=await _subscriptionRepository.findByAccountID(currentAccount!.id!);
        if(currentAccountSubscription!=null){
          accountSubscriptionHistory=await _subscriptionHistoryRepository.findBySubscriptionID(currentAccountSubscription!.id!);
        }
        currentUser=await _userRepo.findByAccountID(currentAccount!.id!);
        if(currentUser==null){
          debugPrint('Current User is null');
        }
      }



      accountLoading=false;
      notifyListeners();
    }catch(e){
      debugPrint('MainWrapper, Find account by id error:${e}');
      accountLoading=false;
      notifyListeners();
    }
  }

}
