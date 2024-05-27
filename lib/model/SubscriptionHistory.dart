import 'dart:ffi';

class SubscriptionHistory {
  int? id;
  String name;
  Float price;
  DateTime? start;
  DateTime? end;

  SubscriptionHistory(
      {this.id, required this.name, required this.price, this.start, this.end});

  factory SubscriptionHistory.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistory(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        start: json['start'] != null ? DateTime.parse(json['start']) : null,
        end: json['end'] != null ? DateTime.parse(json['end']) : null);
  }
}
