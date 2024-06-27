import 'package:sqflite/sqflite.dart';

import '../../model/Account.dart';
import 'database_helper.dart';

class AccountProvider {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<Account> insert(Account account) async {
    final db = await _databaseHelper.database;
    account.id = await db.insert('account', account.toJson());
    return account;
  }

// Các phương thức khác cho AccountProvider
}
