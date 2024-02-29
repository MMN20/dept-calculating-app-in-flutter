import 'package:flutter/material.dart';
import 'package:my_dept_app/global/global.dart';
import 'package:my_dept_app/models/customer.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.costumer,
  });

  final Customer costumer;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        tileColor: const Color.fromARGB(255, 65, 51, 190),
        title: Text(
          costumer.name,
          style: const TextStyle(fontSize: 25),
        ),
        subtitle: Text(
          moneyFraction(costumer.depts - costumer.payings),
          style: const TextStyle(fontSize: 25, color: deptColor),
        ),
      ),
    );
  }
}
