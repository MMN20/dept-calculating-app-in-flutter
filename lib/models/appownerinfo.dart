import 'package:my_dept_app/data_access/database.dart';

class AppOwnerInfo {
  static String? name;
  static String? shopName;

  static Future<bool> getOwnerInfo() async {
    List<Map<String, dynamic>> res =
        await MyDatabase.select('select * from appOwnerInfo');
    if (res.length == 0) {
      return false;
    }

    name = res[0]['name'];
    shopName = res[0]['shopName'];
    return true;
  }

  static Future<void> insertUserInfo() async {
    await MyDatabase.insert(
        'insert into appOwnerInfo (name,shopName) values (?,?)',
        [name, shopName]);
  }
}
