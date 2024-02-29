import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_dept_app/global/global.dart';
import 'package:my_dept_app/models/customer.dart';
import 'package:my_dept_app/models/dept.dart';
import 'package:my_dept_app/models/paying.dart';
import 'package:my_dept_app/providers/refresh_main_provider.dart';
import 'package:my_dept_app/widgets/my_button.dart';
import 'package:my_dept_app/widgets/my_text_field.dart';

class AddPayingDeptScreen extends StatefulWidget {
  const AddPayingDeptScreen(
      {super.key, required this.customer, required this.isDept});
  final Customer customer;
  final bool isDept;
  @override
  State<AddPayingDeptScreen> createState() => _AddPayingDeptScreenState();
}

class _AddPayingDeptScreenState extends State<AddPayingDeptScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    _notesController.dispose();
  }

  DateTime dateTime = DateTime.now();

  bool isValidInput() {
    if (_amountController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى ملئ القيمة اولاً',
            style: scackBarTextStyle,
          ),
        ),
      );
      return false;
    }
    if (double.tryParse(_amountController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '(,) يرجى ملئ القيمة بشكل صحيح وبدون فواصل',
            style: scackBarTextStyle,
          ),
        ),
      );
      return false;
    }
    return true;
  }

  void addDept() async {
    if (!isValidInput()) {
      return;
    }

    Dept dept = Dept(
      deptID: 0,
      deptAmount: double.parse(_amountController.text),
      customerID: widget.customer.ID,
      date: dateTime,
      deptNotes: _notesController.text,
    );
    int res = await widget.customer.addADept(dept);

    print('the res isssss ========================== $res');

    await RefreshMainProvider.instance!.getAllCostumers();

    _amountController.text = '';
    _notesController.text = '';

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        'تم اضافة الدين بنجاح',
        style: scackBarTextStyle,
      ),
    ));
  }

  void addPaying() async {
    if (!isValidInput()) {
      return;
    }

    Paying paying = Paying(
        payingID: 0,
        payingAmount: double.parse(_amountController.text),
        customerID: widget.customer.ID,
        date: dateTime,
        payingNotes: _notesController.text);

    await widget.customer.addAPaying(paying);

    await RefreshMainProvider.instance!.getAllCostumers();

    _amountController.text = '';
    _notesController.text = '';

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
      'تم اضافة تسديد الدين بنجاح',
      style: scackBarTextStyle,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.isDept
                    ? Text(
                        'اضافة دين ',
                        style: const TextStyle(fontSize: 30, color: deptColor),
                      )
                    : Text(
                        'تسديد دين ',
                        style:
                            const TextStyle(fontSize: 30, color: payingColor),
                      ),
                const SizedBox(
                  height: 35,
                ),
                MyTextField(
                  text: 'القيمة',
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 15,
                ),
                MyButton(
                  onPressed: () async {
                    DateTime? dt = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2024),
                      initialDate: DateTime.now(),
                    );
                    if (dt != null) {
                      dateTime = dt;
                    }
                  },
                  color: Colors.blue,
                  text: 'اختر التاريخ (اليوم تلقائياً)',
                ),
                const SizedBox(
                  height: 15,
                ),
                MyTextField(
                  text: 'ملاحظات (اختياري)',
                  controller: _notesController,
                ),
                const SizedBox(
                  height: 15,
                ),
                MyButton(
                  onPressed: widget.isDept ? addDept : addPaying,
                  color: widget.isDept ? deptColor : payingColor,
                  text: 'تم',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
