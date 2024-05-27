
class User{
  int? id;
  String name;
  String? phone_number;
  String? address;

  User({this.id,required this.name,this.phone_number,this.address});

  factory User.fromJson(Map<String,dynamic> json){
    return User(
      id: json['id'],
      name:json['name'],
      phone_number: json['phone_number'],
      address: json['address'],
    );
  }

}