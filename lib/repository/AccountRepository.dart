import 'package:ebook/model/Account.dart';

import '../api/AccountAPI.dart';

class AccountRepository{

  final AccountAPI _apiService = AccountAPI();

  Future<Account?> findByID(int id) async {
    final response = await _apiService.findByID(id);
    if(response.data['account']!=null){
      Account account = Account.fromJson(response.data['account']);
      return account;
    }
    return null;
  }

  Future<Account?> findByEmail(String email) async {
    final response = await _apiService.findByEmail(email);
    if(response.data['account']!=null){
      Account account = Account.fromJson(response.data['account']);
      return account;
    }
    return null;
  }

  Future<Account?> signIn(String email,String password) async {
    final response = await _apiService.signIn(email, password);
    if(response.data['account']!=null){
      Account account = Account.fromJson(response.data['account']);
      return account;
    }
    return null;
  }

  Future<Account> create(Account account) async {
    final response = await _apiService.createAccount(account);
    Account createdAccount = Account.fromJson(response.data['account']);
    return createdAccount;
  }
}