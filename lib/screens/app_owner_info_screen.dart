import 'package:flutter/material.dart';
import 'package:my_dept_app/main.dart';
import 'package:my_dept_app/models/appownerinfo.dart';
import 'package:my_dept_app/widgets/my_button.dart';
import 'package:my_dept_app/widgets/my_text_field.dart';

class AppOwnerInfoScreen extends StatefulWidget {
  const AppOwnerInfoScreen({super.key});

  @override
  State<AppOwnerInfoScreen> createState() => _AppOwnerInfoScreenState();
}

class _AppOwnerInfoScreenState extends State<AppOwnerInfoScreen> {
  final TextEditingController _appOwnerController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();

  void saveData() async {
    AppOwnerInfo.name = _appOwnerController.text;
    AppOwnerInfo.shopName = _shopNameController.text;
    await AppOwnerInfo.insertUserInfo();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (c) => const MyApp()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyTextField(
            text: 'اسمك مالك التطبيق',
            controller: _appOwnerController,
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            text: 'اسم المحل',
            controller: _shopNameController,
          ),
          const SizedBox(
            height: 10,
          ),
          MyButton(
            onPressed: saveData,
            color: Colors.blue,
            text: 'موافق',
          )
        ],
      )),
    );
  }
}
