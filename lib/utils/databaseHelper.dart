import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:calory_calc/models/dbModels.dart';

import 'dateHalper.dart';

class DBUserProvider {
  DBUserProvider._();

  static final DBUserProvider db = DBUserProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Users.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Users ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "surname TEXT"
          ")");
    });
  }

  Future<int>addUser(User user) async{
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into Users (id, name, surname)"
        " VALUES (?,?,?)",
        [0, 
        user.name,
        user.surname,
        ]);
      print(raw);
    return raw;
  }

  Future<User> getUser() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Users");
      var item = res.first;
      User user = User(
        id: item['id'],
        name: item['name'],
        surname: item['surname']
      );

    return user;
  }
}

class DBProductProvider {
  DBProductProvider._();

  static final DBProductProvider db = DBProductProvider._();

  Database _database;
  var rng = new Random();
  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }
  
  firstCreateTable() async{
    final db = await database;
    int id = 0;
    var raw = await db.rawInsert(
        "INSERT Into Products (id, name, category, calory, squi, fat, carboh)"
        " VALUES (?,?,?,?,?,?,?)",
        [id,'Говядина отборная', 'Говядина и телятина', 218, 18.6, 16, 0]
        );
    print("Первая запись");
    return(raw);
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Products.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          print("БД создана");
      await db.execute("CREATE TABLE Products ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "category TEXT,"
          "calory DOUBLE,"
          "squi DOUBLE,"
          "fat DOUBLE,"
          "carboh DOUBLE"
          ")");
    });
  }

  Future<int>addProduct(Product product) async{
    final db = await database;
    // var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Products");
    // int id = table.first["id"];
    int id =rng.nextInt(100)*rng.nextInt(100)+rng.nextInt(100)*rng.nextInt(100)*rng.nextInt(1200);
    var raw = await db.rawInsert(
        "INSERT Into Products (id, name, category, calory, squi, fat, carboh)"
        " VALUES (?,?,?,?,?,?,?)",
        [id, 
        product.name,
        product.category,
        product.calory,
        product.squi,
        product.fat,
        product.carboh,
        // product.date,
        ]);
      print(id.toString() + product.name + product.category + product.carboh.toString());
    return id;
  }

  Future<Product> getProductById(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Products WHERE id = $id");
      var item = res.first;
      Product product = Product(
        id: item["id"],
        name: item["name"],
        category: item["category"],
        calory: item["calory"],
        squi: item["squi"],
        fat: item["fat"],
        carboh: item["carboh"],
        // date: DateTime.fromMillisecondsSinceEpoch(item["date"]),
      );

    return product;
  }

      Future<List<Product>> getAllProductsSearch(String text) async {
        print(1);
        final db = await database;
        var res = await db.query("Products", where: "name LIKE ?", whereArgs: ["%$text%"]);
        List<Product> list =
            res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() : [];
        //     for (int i = 0; i <list.length; i++){
        //       print(i.toString() + list[i].name.toString());
        //     }
        // print(list.length.toString() + "Кол-во ссаных заметок");
        return list;
      }

      Future<List<Product>> getAllProducts() async {
        // print("Я зашёл в поиск");
        final db = await database;
        var res = await db.rawQuery("SELECT * FROM Products LIMIT 10 OFFSET 0");
        List<Product> list =
            res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() : [];
        //     for (int i = 0; i <list.length; i++){
        //       // print(i.toString() + list[i].name.toString());
        //     }
        // print(list.length.toString() + "Кол-во ссаных заметок");
        return list;
      }

}

class DBUserProductsProvider {
  DBUserProductsProvider._();

  static final DBUserProductsProvider db = DBUserProductsProvider._();

  Database _database;
  var rng = new Random();
  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }
  
  firstCreateTable() async{
    final db = await database;
    int id = 0;
    var now = getDateDayAgo(toStrDate(DateTime.now()));
    var raw = await db.rawInsert(
        "INSERT Into UserProducts (id, name, category, calory, squi, fat, carboh, date)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [id,'Говядина отборная', 'Говядина и телятина', 218, 18.6, 16, 0, now]
        );
    print("Первая запись");
    return(raw);
  }


  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "UserProducts.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          print("БД создана");
      await db.execute("CREATE TABLE UserProducts ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "category TEXT,"
          "calory DOUBLE,"
          "squi DOUBLE,"
          "fat DOUBLE,"
          "carboh DOUBLE,"
          "date TEXT" 
          ")");
    });
  }

  toStrDate(DateTime date){
    return date.day.toString()+'.'+date.month.toString()+'.'+date.year.toString();
  }

  Future<DateAndCalory>addProduct(UserProduct product) async{
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM UserProducts");
    int id = table.first["id"];
    var now = DateTime.now();
    var strNow = toStrDate(now);
    // int id =rng.nextInt(100)*rng.nextInt(100)+rng.nextInt(100)*rng.nextInt(100)*rng.nextInt(1200);
    var raw = await db.rawInsert(
        "INSERT Into UserProducts (id, name, category, calory, squi, fat, carboh, date)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [id, 
        product.name,
        product.category,
        product.calory,
        product.squi,
        product.fat,
        product.carboh,
        strNow,
        ]);
      print(strNow);
    return DateAndCalory(id:id,date:strNow);
  }

  Future<UserProduct> getProductById(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM UserProducts WHERE id = $id");
      var item = res.first;
      UserProduct product = UserProduct(
        id: item["id"],
        name: item["name"],
        category: item["category"],
        calory: item["calory"],
        squi: item["squi"],
        fat: item["fat"],
        carboh: item["carboh"],
        date: item["date"],
      );

    return product;
  }

  
  Future<List<UserProduct>> getTodayProducts() async{
    var now = toStrDate(DateTime.now());
    return await getProductsByDate(now);
  }

  Future<List<UserProduct>> getYesterdayProducts() async{
    var yesterday = getDateDayAgo(toStrDate(DateTime.now()));
    return await getProductsByDate(yesterday);
  }

  Future<List<UserProduct>> getProductsByDate(String date) async {
        final db = await database;
        var res = await db.rawQuery("SELECT * FROM UserProducts WHERE date = '$date'");
        List<UserProduct> list =
            res.isNotEmpty ? res.map((c) => UserProduct.fromMap(c)).toList() : [];
        return list;
      }

  deleteAll() async {
    final db = await database;
    db.rawQuery("DELETE FROM UserProducts");
  }

  Future<List<UserProduct>> getAllProducts() async {
        final db = await database;

        var now = toStrDate(DateTime.now());
        var res = await db.rawQuery("SELECT * FROM UserProducts WHERE date = '$now'");
        List<UserProduct> list =
            res.isNotEmpty ? res.map((c) => UserProduct.fromMap(c)).toList() : [];
        return list;
      }

    Future<List<DateAndCalory>> getAllProductsDateSplit() async {
        final db = await database;

        var result = List<DateAndCalory>();
        var count = 0;
        var res = await db.rawQuery("SELECT * FROM UserProducts");

        List<UserProduct> list =
          res.isNotEmpty ? res.map((c) => UserProduct.fromMap(c)).toList() : [];

        for (var i = 0; i < list.length; i++) {
          result.add(DateAndCalory(id: list[i].id,date: list[i].date,calory: list[i].calory));
        }

        return result;
      }
}

class DateAndCalory {
  int id;
  String date;
  double calory;

  DateAndCalory({
    this.id,
    this.date,
    this.calory,
  });
  
}

class DBDateProductsProvider {
  DBDateProductsProvider._();

  static final DBDateProductsProvider db = DBDateProductsProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "DateProducts.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE DateProducts ("
          "id INTEGER PRIMARY KEY,"
          "date TEXT,"
          "ids TEXT"
          ")");
    });
  }

  Future<DateProducts>addDateProducts(DateProducts dateProducts) async{
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM DateProducts");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into DateProducts (id, date, ids)"
        " VALUES (?,?,?)",
        [id, 
        dateProducts.date,
        dateProducts.ids,
        ]);
    var respons = DateProducts(
      id: id,
      date: dateProducts.date,
      ids: dateProducts.ids,
    );
    return respons;
  }

  Future<List<int>> getPoductsIDsByDate(String date) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM DateProducts WHERE date = '$date'");
    var item = res.first;
    var ids = item['ids'];
    var mass = ids.split(";");
    List<int> result = []; 
    for (var i = 0; i < mass.length; i++) {
      result.add(int.parse(mass[i]));
    }
    return result;
  }

  Future<DateProducts> getPoductsByDate(String date) async {
    final db = await database;
    DateProducts respons;
    var res = await db.rawQuery("SELECT * FROM DateProducts WHERE date = '$date'");
    if(res.length == 0){
      var newDP = DateProducts(ids: "", date: toStrDate(DateTime.now()));
      addDateProducts(newDP).then((response){
        var item = res.first;
        respons = DateProducts(id:item['id'], ids: item['ids'], date: item['date']);
      });
    }
    else{
      var item = res.first;
      respons = DateProducts(id:item['id'], ids: item['ids'], date: item['date']);
    }
    return respons;
  }
  
  updateDateProducts(DateProducts products) async{
    final db = await database;
    int count = await db.rawUpdate(
      'UPDATE DateProducts SET ids = ? WHERE id = ?',
      ['${products.ids}', '${products.id}']);
    print('updated: $count');
  }

    Future<List<DateProducts>> getDates() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM DateProducts");
      List<DateProducts> list =
          res.isNotEmpty ? res.map((c) => DateProducts.fromMap(c)).toList() : [];
    return list;
  }

  toStrDate(DateTime date){
    return date.day.toString()+'.'+date.month.toString()+'.'+date.year.toString();
  }
}