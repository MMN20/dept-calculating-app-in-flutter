import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  static late Database db;

  static Future<void> initialDB() async {
    String path = await getDatabasesPath();
    String mydbPath = join(path, 'dept.db');
    Database myDB = await openDatabase(mydbPath,
        onCreate: _onCreate, onUpgrade: _onUpgrade, version: 1);
    db = myDB;
  }

  static Future<void> _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute(''' create table customers (
      ID integer primary key not null ,
      name text not null,
      customerNotes text null
     );''');

    batch.execute(''' create table depts (
      deptID integer primary key not null ,
      deptAmount real not null,
      customerID integer not null,
      date text not null,
      deptNotes text null,
      foreign key (customerID) references customers(ID)
     );''');

    batch.execute(''' create table payings (
      payingID integer primary key not null ,
      payingAmount real not null,
      customerID integer not null,
      date text not null,
      payingNotes text null,
      foreign key (customerID) references customers(ID)
     );''');

    // the first important view
    batch.execute('''
      create view payingView as select ID, name, sum(payingAmount) as totalPaying,customerNotes from customers  left join payings on ID = customerID group by ID,name,customerNotes;
      ''');

    // the second important view
    batch.execute('''
       create view deptView as select ID, name, sum(deptAmount) as totalDept from customers  left join depts on ID = customerID group by ID, name;
      ''');

    batch.execute('''
       create view mainView as select deptView.ID, deptView.name , payingView.customerNotes , deptView.totalDept, payingView.totalPaying  from deptView inner join payingView on deptView.ID = payingView.ID;
      ''');

    batch.execute('''
    create table appOwnerInfo (
      name text not null,
      shopName text not null
    );
''');

    batch.execute('create table firstTime (isPass integer not null);');
    batch.execute('insert into firstTime (isPass) values (0);');
    await batch.commit();

    print(
        'created the new tablesssss ============================================================= yaaaaaaay');
  }

  static void _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  static Future<List<Map<String, dynamic>>> select(String sql,
      [List<Object?>? args]) async {
    return await db.rawQuery(sql, args);
  }

  static Future<int> insert(String sql, List<Object?>? args) async {
    return await db.rawInsert(sql, args);
  }

  static Future<int> update(String sql, List<Object?>? args) async {
    return await db.rawUpdate(sql, args);
  }

  static Future<int> delete(String sql, List<Object?>? args) async {
    return await db.rawDelete(sql, args);
  }
}
