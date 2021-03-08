import 'package:enrole_app_dev/home/home.dart';
import 'package:flutter/material.dart';
import 'login/login_screen.dart';
import 'register_user/register_user_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[700],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.blue[700],
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register-user': (context) => RegisterUserPage(),
        '/home': (context) => Home(),
      },
    );
  }
}
