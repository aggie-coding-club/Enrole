import 'package:enrole_app_dev/home/home.dart';
import 'package:flutter/material.dart';
import 'login/login_screen.dart';
import 'register_user/register_user_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(InitApp());
}

class InitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Inistializing Firebase');
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          // TODO: Create a screen from app crash on initialization
          return Text(
            'Something went wrong',
            textDirection: TextDirection.ltr,
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        } else {
          // TODO: Create a splash screen
          return Text(
            'Loading',
            textDirection: TextDirection.ltr,
          );
        }
      },
    );
  }
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
