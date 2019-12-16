import 'package:earthquake_report/auth/login.dart';
import 'package:earthquake_report/auth/register_success.dart';
// import 'package:earthquake_report/auth/register_success.dart';
import 'package:earthquake_report/page/main_page.dart';
import 'package:flutter/material.dart';

// import 'auth/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Color(0xff6469F2),
        accentColor: Color(0xffC2C3DE),
        textTheme: TextTheme(
          body1: TextStyle(
            color: Color(0xff818182),
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
          title: TextStyle(
            color: Color(0xff65679F),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      routes: {
        "/main": (_) => new MainPage(),
        "/login": (_) => new Login(),
        "/registerSuccess": (_) => new RegisterSuccess(),
      },
      debugShowCheckedModeBanner: false,
      home: Login(),
      // home: MainPage(),
    );
  }
}
