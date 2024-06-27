
class Account {
  int? id;
  int user_id;
  int subscription_id;
  String email;
  String password;
  bool is_verified;

  Account(
      {this.id,
      required this.user_id,
      required this.subscription_id,
      required this.email,
      required this.password,
      required this.is_verified});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
        id: json['id'],
        user_id: json['user_id'],
        subscription_id: json['subscription_id'],
        email: json['email'],
        password: json['email'],
        is_verified: json['is_verified']);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': user_id,
      'subscription_id': subscription_id,
      'email': email,
      'password': password,
      'is_verified': is_verified,
    };
  }
}
