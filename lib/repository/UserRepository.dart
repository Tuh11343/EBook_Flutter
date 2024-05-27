import 'package:ebook/api/UserAPI.dart';
import 'package:ebook/model/User.dart';

class UserRepository {
  final UserAPI apiService = UserAPI();

  Future<User?> create(User user) async {
    final response = await apiService.createUser(user);
    if (response.data['user'] != null) {
      return User.fromJson(response.data['user']);
    }
    return null;
  }

  Future<User?> findByID(int id) async {
    final response = await apiService.findByID(id);
    if (response.data['user'] != null) {
      return User.fromJson(response.data['user']);
    }
    return null;
  }

  Future<User?> findByAccountID(int accountID) async {
    final response = await apiService.findByAccountID(accountID);
    if (response.data['user'] != null) {
      return User.fromJson(response.data['subscription']);
    }
    return null;
  }
}
