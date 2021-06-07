import 'package:enrole_app_dev/services/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:enrole_app_dev/main.dart';

class AdminFloatingActionButton extends StatefulWidget {
  // const AdminFloatingActionButton({ Key? key }) : super(key: key);

  @override
  _AdminFloatingActionButtonState createState() => _AdminFloatingActionButtonState();
}

class _AdminFloatingActionButtonState extends State<AdminFloatingActionButton> {

  JoinedOrg _currentOrg;
  
  @override
  Widget build(BuildContext context) {

    return SpeedDial(
      buttonSize: 56.0,
      icon: Icons.add,
      activeIcon: Icons.keyboard_arrow_right_rounded,
      visible: true,
      shape: CircleBorder(),
      elevation: 8.0,
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      closeManually: false,
      children: [
        SpeedDialChild(
          child: Icon(Icons.accessibility),
          backgroundColor: Colors.red,
          label: 'First',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('FIRST CHILD'),
          onLongPress: () => print('FIRST CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Icon(Icons.brush),
          backgroundColor: Colors.blue,
          label: 'Second',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('SECOND CHILD'),
          onLongPress: () => print('SECOND CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Icon(Icons.keyboard_voice),
          backgroundColor: Colors.green,
          label: 'Third',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('THIRD CHILD'),
          onLongPress: () => print('THIRD CHILD LONG PRESS'),
        ),
      ],
    );
  }
}