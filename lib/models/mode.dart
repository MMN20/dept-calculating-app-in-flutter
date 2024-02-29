import 'package:my_dept_app/data_access/database.dart';

class Pass {
  static Future<bool> isPass() async {
    List<Map<String, dynamic>> res =
        await MyDatabase.select('select isPass from firstTime');
    return res[0]['isPass'] != 0;
  }

  static Future<void> setPassToOne() async {
    await MyDatabase.insert('update firstTime set isPass = (?)', [1]);
  }
}
