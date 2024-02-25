import 'package:flutter/material.dart';
import 'package:learn/View/Box.dart';
import 'package:learn/View/homepage.dart';
import 'package:get/get.dart';
import 'package:learn/View/screen1.dart';
import 'package:learn/middleware/authmiddleware.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedpref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedpref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //initialBinding: Box(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      getPages: [
        GetPage(
            name: "/",
            page: () => Homepage(),
             middlewares: [AuthMiddleWare()]
            ),
        GetPage(name: "/m1", page: () => Screen1())
      ],
    );
  }
}
