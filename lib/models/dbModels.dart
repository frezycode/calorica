import 'dart:convert';

class User {
  int id;
  String name;
  String surname;

  User({
		this.id,
    this.name,
    this.surname
  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
      );
      
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "surname": surname,
      };
}

class Product {
  int id;
  String name;
  String category;
  double calory;
  double squi;
  double fat;
  double carboh;
  // DateTime date;

  Product({
		this.id,
    this.name,
    this.category,
    this.calory,
    this.squi,
    this.fat,
    this.carboh,
    // this.date,
  });

  factory Product.fromMap(Map<String, dynamic> json) => new Product(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        calory: json["calory"],
        squi: json["squi"],
        fat: json["fat"],
        carboh: json["carboh"],
        // date: DateTime.fromMillisecondsSinceEpoch(json["date"]),
      );
      
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "category": category,
        "calory": calory,
        "squi": squi,
        "fat": fat,
        "carboh": carboh,
        // "date": epochFromDate( date ),
      };

      // epochFromDate(DateTime dt) {  
      //   return dt.millisecondsSinceEpoch ~/ 1000;
      // }
}


class UserProduct {
  int id;
  String name;
  String category;
  double calory;
  double squi;
  double fat;
  double carboh;
  String date;

  UserProduct({
		this.id,
    this.name,
    this.category,
    this.calory,
    this.squi,
    this.fat,
    this.carboh,
    this.date,
  });

  factory UserProduct.fromMap(Map<String, dynamic> json) => new UserProduct(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        calory: json["calory"],
        squi: json["squi"],
        fat: json["fat"],
        carboh: json["carboh"],
        date: json["date"],
      );
      
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "category": category,
        "calory": calory,
        "squi": squi,
        "fat": fat,
        "carboh": carboh,
        "date": date ,
      };

      // epochFromDate(DateTime dt) {  
      //   return dt.millisecondsSinceEpoch ~/ 1000;
      // }
}

class DateProducts {
  String ids;
  String date;
  int id;

  DateProducts({
    this.date,
    this.id,
    this.ids,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'id': id,
      'ids' : ids,
    };
  }

  static DateProducts fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return DateProducts(
      date: map['date'],
      id: map['id'],
      ids: map['ids'],
    );
  }

  String toJson() => json.encode(toMap());

  static DateProducts fromJson(String source) => fromMap(json.decode(source));
}
