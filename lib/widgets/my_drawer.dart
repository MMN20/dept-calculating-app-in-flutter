import 'package:flutter/material.dart';
import 'package:my_dept_app/models/appownerinfo.dart';
import 'package:my_dept_app/models/developer_info.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppOwnerInfo.name!,
                  style: const TextStyle(fontSize: 30),
                  softWrap: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  AppOwnerInfo.shopName!,
                  style: const TextStyle(fontSize: 30),
                  softWrap: true,
                ),
                const Spacer(),
                const Text(
                  'مطور البرنامج: $developerName',
                  style: TextStyle(fontSize: 15),
                  softWrap: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                // whatsApp
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/WhatsApp_icon.png',
                      height: 15,
                    ),
                    const Text(
                      ' $developerPhoneNumber',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),

                // Telegram
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/telegram.png',
                      height: 15,
                    ),
                    const Text(
                      ' $developerTelegram',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
