import 'package:flutter/material.dart';
import 'package:my_dept_app/global/global.dart';
import 'package:my_dept_app/models/customer.dart';
import 'package:my_dept_app/models/dept.dart';
import 'package:my_dept_app/models/paying.dart';
import 'package:intl/intl.dart';
import 'package:my_dept_app/providers/refresh_main_provider.dart';
import 'package:my_dept_app/widgets/my_button.dart';
import 'package:my_dept_app/widgets/my_text_field.dart';

class DeptPayingCard extends StatefulWidget {
  const DeptPayingCard(
      {super.key,
      this.dept,
      this.paying,
      required this.customer,
      required this.depts,
      required this.payings,
      required this.refreshMainScreen});
  final Dept? dept;
  final Paying? paying;
  final Customer customer;
  final List<Dept> depts;
  final List<Paying> payings;
  final void Function() refreshMainScreen;

  @override
  State<DeptPayingCard> createState() => _DeptPayingCardState();
}

class _DeptPayingCardState extends State<DeptPayingCard> {
  late bool isDept;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  late DateTime dateTime;
  bool isAnimateOpacity = false;

  @override
  void initState() {
    super.initState();
    isDept = widget.dept != null;

    if (isDept) {
      dateTime = widget.dept!.date;
      _amountController.text = widget.dept!.deptAmount.toStringAsFixed(0);
      _notesController.text = widget.dept!.deptNotes ?? '';
    } else {
      dateTime = widget.paying!.date;
      _amountController.text = widget.paying!.payingAmount.toStringAsFixed(0);
      _notesController.text = widget.paying!.payingNotes ?? '';
    }
  }

  Future<void> deleteDepts() async {
    await widget.customer.deleteThisDeptFromCustomer(widget.dept!.deptID);
    widget.depts.remove(widget.dept!);
    widget.refreshMainScreen();
  }

  Future<void> deletePaying() async {
    await widget.customer.deleteThisPayingFromCustomer(widget.paying!.payingID);
    widget.payings.remove(widget.paying!);
    widget.refreshMainScreen();
  }

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

  void updateDept() async {
    if (!isValidInput()) {
      return;
    }
    widget.dept!.date = dateTime;
    widget.dept!.deptAmount = double.parse(_amountController.text);
    widget.dept!.deptNotes =
        _notesController.text == '' ? null : _notesController.text;
    await widget.customer.updateThisDept(widget.dept!);
    widget.refreshMainScreen();
  }

  void updatePaying() async {
    if (!isValidInput()) {
      return;
    }
    widget.paying!.date = dateTime;
    widget.paying!.payingAmount = double.parse(_amountController.text);
    widget.paying!.payingNotes =
        _notesController.text == '' ? null : _notesController.text;

    await widget.customer.updateThisPaying(widget.paying!);
    widget.refreshMainScreen();
  }

  Future<void> editButton() async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (c) {
        return SingleChildScrollView(
          child: Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isDept
                      ? Text(
                          'تعديل الدَين ',
                          style:
                              const TextStyle(fontSize: 30, color: deptColor),
                        )
                      : Text(
                          'تعديل تسديد الدَين ',
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
                        lastDate: DateTime(2100),
                        initialDate: dateTime,
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
                    onPressed: () async {
                      if (isDept) {
                        updateDept();
                        await RefreshMainProvider.instance!.getAllCostumers();
                      } else {
                        updatePaying();
                        await RefreshMainProvider.instance!.getAllCostumers();
                      }
                      // showDialog(
                      //     context: context,
                      //     builder: (c) => AlertDialog(
                      //           title: Center(child: Text('تم التعديل بنجاح')),

                      //         ));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تم التعديل بنجاح',
                          ),
                        ),
                      );

                      setState(() {
                        isAnimateOpacity = true;
                      });
                    },
                    color: isDept ? deptColor : payingColor,
                    text: 'تم',
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  void showDeleteSubDialog() {
    showDialog(
        context: context,
        builder: (c) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  child: const Center(
                    child: Text(
                      'موافق',
                      style: TextStyle(fontSize: dialogFontSize),
                    ),
                  ),
                  onPressed: () async {
                    if (widget.dept == null) {
                      await deletePaying();
                    } else {
                      await deleteDepts();
                    }
                    await RefreshMainProvider.instance!.getAllCostumers();

                    Navigator.pop(context);
                  },
                ),
                SimpleDialogOption(
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
            ));
  }

  void moreButton(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => SimpleDialog(
        children: [
          SimpleDialogOption(
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
            onPressed: () {
              Navigator.pop(context);
              showDeleteSubDialog();
            },
          ),
          SimpleDialogOption(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'تعديل',
                  style: TextStyle(fontSize: dialogFontSize),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.edit,
                  color: Colors.blue,
                )
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
              editButton();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = isDept ? deptColor : payingColor;
    double number =
        isDept ? widget.dept!.deptAmount : widget.paying!.payingAmount;

    String notes = isDept
        ? widget.dept!.deptNotes ?? ''
        : widget.paying!.payingNotes ?? '';

    DateTime date = isDept ? widget.dept!.date : widget.paying!.date;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isAnimateOpacity ? 0.8 : 1,
      onEnd: () {
        setState(() {
          isAnimateOpacity = false;
        });
      },
      child: Card(
        elevation: 5,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          tileColor:
              isAnimateOpacity ? Colors.blueGrey[500] : Colors.blueGrey[900],
          title: Text(
            moneyFraction(number),
            style: TextStyle(fontSize: 25, color: textColor),
          ),
          subtitle: Text(
            notes,
            style: const TextStyle(fontSize: 18),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('dd/MM/yyyy').format(date),
                style: const TextStyle(fontSize: 15),
              ),
              IconButton(
                onPressed: () {
                  moreButton(context);
                },
                icon: const Icon(Icons.more_vert),
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
