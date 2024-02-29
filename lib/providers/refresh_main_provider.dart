import 'package:flutter/foundation.dart';
import 'package:my_dept_app/models/customer.dart';

class RefreshMainProvider extends ChangeNotifier {
  void refreshScreen() {
    notifyListeners();
  }

  List<Customer> costumers = [];
  String searchText = '';

  // this function will refresh the main screen with the new data
  Future<void> getAllCostumers() async {
    costumers = await Customer.searchForCustomersByName(searchText);
    print(
        '${costumers.length} ==================================== costumerssssss');
    notifyListeners();
  }

  static RefreshMainProvider? instance;

  RefreshMainProvider() {
    instance = this;
    getAllCostumers();
  }
}
