import 'package:flutter/material.dart';
import 'package:my_dept_app/global/global.dart';
import 'package:my_dept_app/models/customer.dart';
import 'package:my_dept_app/models/dept.dart';
import 'package:my_dept_app/models/paying.dart';
import 'package:my_dept_app/widgets/dept_paying_card.dart';

class DeptsPayingsDetailsScreen extends StatefulWidget {
  const DeptsPayingsDetailsScreen({super.key, required this.customer});
  final Customer customer;

  @override
  State<DeptsPayingsDetailsScreen> createState() =>
      _DeptsPayingsDetailsScreenState();
}

class _DeptsPayingsDetailsScreenState extends State<DeptsPayingsDetailsScreen> {
  List<Dept> depts = [];
  List<Paying> payings = [];

  @override
  void initState() {
    super.initState();
    getDeptsAndPayings();
  }

  void refreshThisScreen() {
    setState(() {});
  }

  void getDeptsAndPayings() async {
    depts = await widget.customer.getAllDeptsOfThisCustomer();
    payings = await widget.customer.getAllPayingsOfThisCustomer();
    setState(() {});
  }

  Widget getListAllDepts() {
    if (depts.length == 0) {
      return Center(
        child: Text('${widget.customer.name} لا يوجد اي ديون لدى'),
      );
    }
    return ListView.builder(
      itemCount: depts.length,
      itemBuilder: (context, index) {
        return DeptPayingCard(
          refreshMainScreen: refreshThisScreen,
          depts: depts,
          payings: payings,
          customer: widget.customer,
          dept: depts[index],
        );
      },
    );
  }

  Widget getListAllPayings() {
    if (payings.length == 0) {
      return Center(
        child: Text('${widget.customer.name} لا يوجد اي مدفوعات لدى'),
      );
    }
    return ListView.builder(
      itemCount: payings.length,
      itemBuilder: (context, index) {
        return DeptPayingCard(
          refreshMainScreen: refreshThisScreen,
          depts: depts,
          payings: payings,
          customer: widget.customer,
          paying: payings[index],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              Text(
                widget.customer.name,
                style: const TextStyle(fontSize: 25),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 20),
            tabs: [
              Tab(
                child: Text(
                  'الديون',
                  style: TextStyle(color: deptColor),
                ),
              ),
              Tab(
                child: Text(
                  'المدفوعات',
                  style: TextStyle(color: payingColor),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            getListAllDepts(),
            getListAllPayings(),
          ],
        ),
      ),
    );
  }
}
