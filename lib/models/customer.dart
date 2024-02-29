import 'package:my_dept_app/data_access/database.dart';
import 'package:my_dept_app/models/dept.dart';
import 'package:my_dept_app/models/paying.dart';
import 'package:sqflite/sqflite.dart';

class Customer {
  int ID;
  String name;
  String? customerNotes;
  double depts;
  double payings;

  Customer({
    required this.ID,
    required this.name,
    this.customerNotes,
    required this.depts,
    required this.payings,
  });

  Future<int> insert() async {
    int res = await MyDatabase.insert(
        'insert into customers (name,customerNotes) values (?,?)',
        [name, customerNotes]);
    ID = res;
    return res;
  }

  Future<bool> update() async {
    int res = await MyDatabase.update(
        'update customers set name = ?, customerNotes = ? where ID = ?',
        [name, customerNotes, ID]);
    return res > 0;
  }

  static Future<bool> deleteCustomer(int id) async {
    Batch batch = MyDatabase.db.batch();
    batch.execute('delete from payings where customerID = ?', [id]);
    batch.execute('delete from depts where customerID = ?', [id]);
    await batch.commit();

    int res =
        await MyDatabase.delete('delete from customers where ID = ?', [id]);

    return res > 0;
  }

  // get all the paying processes that this customer had done
  Future<List<Paying>> getAllPayingsOfThisCustomer() async {
    List<Map<String, dynamic>> rows = await MyDatabase.select(
        'select * from payings where customerID = ?', [ID]);

    List<Paying> list = [];

    for (var row in rows) {
      DateTime dateTime = DateTime.parse(row['date']);

      list.add(
        Paying(
          payingID: row['payingID'],
          payingAmount: row['payingAmount'],
          customerID: row['customerID'],
          date: dateTime,
          payingNotes: row['payingNotes'],
        ),
      );
    }

    return list;
  }

  // get all the depts processes that this customer had done
  Future<List<Dept>> getAllDeptsOfThisCustomer() async {
    List<Map<String, dynamic>> rows = await MyDatabase.select(
        'select * from depts where customerID = ?', [ID]);

    List<Dept> list = [];

    for (var row in rows) {
      DateTime dateTime = DateTime.parse(row['date']);

      list.add(
        Dept(
          deptID: row['deptID'],
          deptAmount: row['deptAmount'],
          customerID: row['customerID'],
          date: dateTime,
          deptNotes: row['deptNotes'],
        ),
      );
    }

    return list;
  }

  // get all the customers with their full paying and depts as one double varibale
  static Future<List<Customer>> getAllCustomersWithDeptsAndPayings() async {
    List<Map<String, dynamic>> rows = await MyDatabase.select(
        'select ID, name, totalDept, totalPaying, customerNotes from mainView');
    List<Customer> customers = [];

    for (var row in rows) {
      customers.add(
        Customer(
            ID: row['ID'],
            name: row['name'],
            depts: row['totalDept'] ?? 0,
            payings: row['totalPaying'] ?? 0,
            customerNotes: row['customerNotes']),
      );
    }

    print(
        '======================++++++++======++++++== (the fetched rows)  $rows');

    return customers;
  }

  // just the customers
  static Future<List<Customer>> getAllCustomers() async {
    List<Map<String, dynamic>> rows =
        await MyDatabase.select('select * from customers');
    List<Customer> customers = [];

    for (var row in rows) {
      customers.add(
        Customer(
            ID: row['ID'],
            name: row['name'],
            depts: 0,
            payings: 0,
            customerNotes: row['customerNotes']),
      );
    }
    return customers;
  }

  static Future<List<Customer>> searchForCustomersByName(String name) async {
    List<Map<String, dynamic>> rows = await MyDatabase.select(
        'select * from mainView where name like ?', ['%$name%']);
    List<Customer> customers = [];

    for (var row in rows) {
      customers.add(
        Customer(
            ID: row['ID'],
            name: row['name'],
            depts: row['totalDept'] ?? 0,
            payings: row['totalPaying'] ?? 0,
            customerNotes: row['customerNotes']),
      );
    }
    return customers;
  }

  static Future<Customer?> findCustomerByID(int id) async {
    List<Map<String, dynamic>> rows = await MyDatabase.select(
        'select ID, name, totalDept, totalPaying, customerNotes from mainView where ID = ?'[
            id]);

    if (rows.length == 0) {
      return null;
    }
    return Customer(
      ID: rows[0]['ID'],
      name: rows[0]['name'],
      depts: rows[0]['totalDept'],
      payings: rows[0]['totalPaying'],
      customerNotes: rows[0]['customerNotes'],
    );
  }

  Future<int> addADept(Dept dept) async {
    print('dept.deptAmount ==> ${dept.deptAmount}');
    print('ID ==> ${ID}');
    print('dept.date.toString() ==> ${dept.date.toString()}');
    print('dept.deptNotes ==> ${dept.deptNotes}');

    int res = await MyDatabase.insert(
        'INSERT INTO depts (deptAmount,customerID,date,deptNotes) values (?,?,?,?);',
        [dept.deptAmount, ID, dept.date.toString(), dept.deptNotes]);

    return res;
  }

  Future<int> addAPaying(Paying paying) async {
    int res = await MyDatabase.insert(
        'insert into payings (payingAmount,customerID,date,payingNotes) values (?,?,?,?)',
        [paying.payingAmount, ID, paying.date.toString(), paying.payingNotes]);

    return res;
  }

  Future<bool> deleteThisDeptFromCustomer(int deptID) async {
    int res =
        await MyDatabase.delete('delete from depts where deptID = ?', [deptID]);
    return res > 0;
  }

  Future<bool> deleteThisPayingFromCustomer(int payingID) async {
    int res = await MyDatabase.delete(
        'delete from payings where payingID = ?', [payingID]);
    return res > 0;
  }

  Future<bool> updateThisDept(Dept dept) async {
    int res = await MyDatabase.delete(''' 
    update depts set deptAmount = ?,
    date = ?,
    deptNotes = ? where deptID = ?

    ''', [dept.deptAmount, dept.date.toString(), dept.deptNotes, dept.deptID]);
    return res > 0;
  }

  Future<bool> updateThisPaying(Paying paying) async {
    int res = await MyDatabase.delete(''' 
    update payings set payingAmount = ?,
    date = ?,
    payingNotes = ? where payingID = ?

    ''', [paying.payingAmount, paying.date.toString(), paying.payingID]);
    return res > 0;
  }
}
