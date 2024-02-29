import 'package:flutter/material.dart';
import 'package:my_dept_app/global/global.dart';
import 'package:my_dept_app/models/customer.dart';
import 'package:my_dept_app/providers/refresh_main_provider.dart';
import 'package:my_dept_app/widgets/my_button.dart';
import 'package:my_dept_app/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

class AddCostumerScreen extends StatefulWidget {
  const AddCostumerScreen({
    super.key,
  });

  @override
  State<AddCostumerScreen> createState() => _AddCostumerScreenState();
}

class _AddCostumerScreenState extends State<AddCostumerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _ageController.dispose();
  }

  void addNewCostumer() async {
    String name;
    String? notes;

    if (_nameController.text != '') {
      name = _nameController.text;
      notes = _ageController.text != '' ? _ageController.text : null;

      for (var costumer in RefreshMainProvider.instance!.costumers) {
        if (costumer.name == name) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'هذا الاسم موجود بالفعل، يرجى اختيار اسم آخر',
              ),
            ),
          );
          return;
        }
      }

      Customer costumer = Customer(
          ID: 0, name: name, depts: 0, payings: 0, customerNotes: notes);
      await costumer.insert();

      RefreshMainProvider.instance!.costumers.add(costumer);
      RefreshMainProvider.instance!.refreshScreen();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم الاضافة بنجاح! ',
          ),
        ),
      );
      name = _nameController.text = '';
      notes = _ageController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
          bottom: 10 + MediaQuery.of(context).viewInsets.bottom),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'اضافة زبون',
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 25,
            ),
            MyTextField(text: 'ادخل اسم الشخص', controller: _nameController),
            const SizedBox(
              height: 15,
            ),
            MyTextField(text: 'ملاحظات (اختياري)', controller: _ageController),
            const SizedBox(
              height: 15,
            ),
            MyButton(
              onPressed: addNewCostumer,
              color: buttonsColor,
              text: 'تم',
            ),
          ],
        ),
      ),
    );
  }
}
