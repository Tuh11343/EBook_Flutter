
import 'package:ebook/model/Book.dart';

class Subscription {
  int? id;
  int subscription_history_id;
  num duration;
  num price_per_month;
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
      bookType: _parseBookType(json['book_type']),
    );
  }

  static BookType _parseBookType(String type) {
    switch (type) {
      case 'NORMAL':
        return BookType.NORMAL;
      case 'PREMIUM':
        return BookType.PREMIUM;
      default:
        throw ArgumentError('Unknown book type: $type');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'subscription_history_id': subscription_history_id,
      'duration': duration,
      'price_per_month': price_per_month,
      'type': type,
      'limit_book_mark': limit_book_mark,
      'book_type': bookType.toString().split('.').last,
    };
  }
}
