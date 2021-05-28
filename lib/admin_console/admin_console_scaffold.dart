import 'package:flutter/material.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:enrole_app_dev/home/home.dart';



class AdminConsole extends StatefulWidget {
  @override
  _AdminConsoleState createState() => _AdminConsoleState();
}

class _AdminConsoleState extends State<AdminConsole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text('Admin Console'),
      ),
    );
  }
}