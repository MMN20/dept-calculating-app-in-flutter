import 'package:flutter/material.dart';
import 'package:my_dept_app/data_access/database.dart';
import 'package:my_dept_app/models/developer_info.dart';
import 'package:my_dept_app/models/mode.dart';
import 'package:my_dept_app/providers/refresh_main_provider.dart';
import 'package:my_dept_app/screens/home_screen.dart';
import 'package:my_dept_app/widgets/my_button.dart';
import 'package:my_dept_app/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark()
          .copyWith(useMaterial3: true, scaffoldBackgroundColor: Colors.black),
      home: const InitializeDB(),
    );
  }
}

class InitializeDB extends StatefulWidget {
  const InitializeDB({super.key});

  @override
  State<InitializeDB> createState() => _InitializeDBState();
}

class _InitializeDBState extends State<InitializeDB> {
  bool? isDBInitialized;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialDB();
  }

  void initialDB() async {
    await MyDatabase.initialDB();
    isDBInitialized = await Pass.isPass();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isDBInitialized == null) {
      return Container();
    }

    return isDBInitialized!
        ? ChangeNotifierProvider(
            create: (c) => RefreshMainProvider(),
            child: const HomeScreen(),
          )
        : passowrdScreen(context);
  }

  Scaffold passowrdScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'لمعرفة الرمز تواصل مع مبرمج التطبيق',
              style: TextStyle(fontSize: 25),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (c) => SimpleDialog(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    developerName,
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/WhatsApp_icon.png',
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        developerPhoneNumber,
                                        style: TextStyle(fontSize: 25),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/telegram.png',
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        developerTelegram,
                                        style: TextStyle(fontSize: 25),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ));
              },
              icon: const Icon(
                Icons.info,
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            MyTextField(
              text: 'الرمز',
              controller: _passwordController,
            ),
            const SizedBox(
              height: 15,
            ),
            MyButton(
              color: Colors.blue,
              onPressed: () async {
                if (_passwordController.text != '') {
                  if (_passwordController.text == 'MMN20') {
                    await Pass.setPassToOne();
                    isDBInitialized = true;
                    setState(() {});
                  } else {
                    showDialog(
                      context: context,
                      builder: (c) {
                        return const SimpleDialog(
                          title: Center(child: Text('!الرمز خطأ')),
                        );
                      },
                    );
                  }
                }
              },
              text: 'Enter',
            )
          ],
        ),
      ),
    );
  }
}
