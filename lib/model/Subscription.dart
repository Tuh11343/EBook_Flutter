import 'dart:ffi';

import 'package:ebook/model/Book.dart';

class Subscription {
  int? id;
  int subscription_history_id;
  Float duration;
  Float price_per_month;
  String type;
  int limit_book_mark;
  BookType bookType;

  Subscription(
      {this.id,
      required this.subscription_history_id,
      required this.duration,
      required this.price_per_month,
      required this.type,
      required this.limit_book_mark,
      required this.bookType});

  factory Subscription.fromJson(Map<String,dynamic> json){
    return Subscription(
      id: json['id'],
      subscription_history_id: json['subscription_history_id'],
      duration: json['duration'],
      price_per_month: json['price_per_month'],
      type: json['type'],
      limit_book_mark: json['limit_book_mark'],
      bookType: json['book_type'],
    );
  }
}
