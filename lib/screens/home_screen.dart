import 'package:flutter/material.dart';
import 'package:my_dept_app/data_access/database.dart';
import 'package:my_dept_app/global/global.dart';
import 'package:my_dept_app/models/appownerinfo.dart';
import 'package:my_dept_app/models/customer.dart';
import 'package:my_dept_app/models/dept.dart';
import 'package:my_dept_app/providers/refresh_main_provider.dart';
import 'package:my_dept_app/screens/add_costumer_screen.dart';
import 'package:my_dept_app/screens/add_paying_dept_screen.dart';
import 'package:my_dept_app/screens/app_owner_info_screen.dart';
import 'package:my_dept_app/screens/depts_payings_details_screen.dart';
import 'package:my_dept_app/widgets/customer_card.dart';
import 'package:my_dept_app/widgets/my_drawer.dart';
import 'package:my_dept_app/widgets/my_text_field.dart';
import 'package:my_dept_app/widgets/search_text_field.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool? isUserHasInfo;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      RefreshMainProvider.instance!.searchText = _searchController.text;
      RefreshMainProvider.instance!.getAllCostumers();
    });
    checkIsOwnerHasInfo();
  }

  void checkIsOwnerHasInfo() async {
    isUserHasInfo = await AppOwnerInfo.getOwnerInfo();

    setState(() {});
  }

  void navigateToAddPayingDeptScreen(bool isDept, Customer costumer) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => AddPayingDeptScreen(
          customer: costumer,
          isDept: isDept,
        ),
      ),
    ); //! nnnnnnnnnnnnn
  }

  void onTap(Customer customer) {
    showDialog(
        context: context,
        builder: (c) => SimpleDialog(
              title: const Center(
                child: Text('اضافة او تسديد دين'),
              ),
              children: [
                SimpleDialogOption(
                  padding: const EdgeInsets.all(10),
                  child: const Center(
                    child: Text(
                      'دين',
                      style:
                          TextStyle(fontSize: dialogFontSize, color: deptColor),
                    ),
                  ),
                  onPressed: () async {
                    navigateToAddPayingDeptScreen(true, customer);
                  },
                ),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(10),
                  child: const Center(
                    child: Text(
                      'تسديد',
                      style: TextStyle(
                          fontSize: dialogFontSize, color: payingColor),
                    ),
                  ),
                  onPressed: () {
                    navigateToAddPayingDeptScreen(false, customer);
                  },
                ),
              ],
            ));
  }

  void showDeleteSubDialog(Customer customer, List<Customer> customers) {
    showDialog(
      context: context,
      builder: (c) => SimpleDialog(
        title: const Center(child: Text('حذف')),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(10),
            child: const Center(
              child: Text(
                'موافق',
                style: TextStyle(fontSize: dialogFontSize),
              ),
            ),
            onPressed: () async {
              await Customer.deleteCustomer(customer.ID);
              customers.remove(customer);
              Navigator.pop(context);
              setState(() {});
            },
          ),
          // the don't delete choice
          SimpleDialogOption(
            padding: const EdgeInsets.all(10),
            child: const Center(
              child: Text(
                'غير موافق',
                style: TextStyle(fontSize: dialogFontSize),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void onLongPress(Customer customer, List<Customer> customers) {
    showDialog(
        context: context,
        // the main (first) dialog
        builder: (c) => SimpleDialog(
              title: const Center(child: Text('حذف او عرض التفاصيل')),
              children: [
                // the delete main dialog
                SimpleDialogOption(
                  padding: const EdgeInsets.all(10),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'حذف',
                        style: TextStyle(fontSize: dialogFontSize),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      )
                    ],
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    // the delete choice
                    showDeleteSubDialog(customer, customers);
                  },
                ),
                // show details
                SimpleDialogOption(
                  padding: const EdgeInsets.all(10),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'عرض التفاصيل',
                        style: TextStyle(fontSize: dialogFontSize),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.info,
                        color: Colors.blue,
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => DeptsPayingsDetailsScreen(
                          customer: customer,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // we don't know if the user have entered his info
    if (isUserHasInfo == null) {
      return Container();
    }

    // let the user enter his info
    if (!isUserHasInfo!) {
      return const AppOwnerInfoScreen();
    }

    final provider = Provider.of<RefreshMainProvider>(context);

    return Scaffold(
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonsColor,
        onPressed: () async {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (c) {
              return const SingleChildScrollView(child: AddCostumerScreen());
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text(
          'الديون',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //! search text field aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
              SearchTextField(
                text: 'ابحث',
                controller: _searchController,
              ),

              //! search text field aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
              Expanded(
                child: ListView.builder(
                  itemCount: provider.costumers.length,
                  itemBuilder: (context, index) {
                    Customer costumer = provider.costumers[index];
                    return Container(
                      margin: index == 0 ? const EdgeInsets.only(top: 5) : null,
                      child: InkWell(
                        onTap: () {
                          onTap(costumer);
                        },
                        onLongPress: () {
                          onLongPress(costumer, provider.costumers);
                        },
                        child: CustomerCard(costumer: costumer),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
