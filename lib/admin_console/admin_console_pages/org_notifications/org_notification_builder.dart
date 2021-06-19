import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:enrole_app_dev/admin_console/admin_console_pages/manage_members_page/manage_join_requests.dart';

class OrgNotificationBuilder extends StatefulWidget {
  final Map<String, dynamic>? notificationData;

  OrgNotificationBuilder({this.notificationData});

  @override
  _OrgNotificationBuilderState createState() => _OrgNotificationBuilderState();
}

class _OrgNotificationBuilderState extends State<OrgNotificationBuilder> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> notificationData = this.widget.notificationData ?? {};
    switch (notificationData['type']) {
      case 'userJoin':
        return userJoinNotification(notificationData);

      case 'userJoinRequest':
        return userJoinRequestNotification(notificationData, context);

      case 'roleChange':
        return roleChangeNotification(notificationData, context);

      default:
        return errorNotification();

    }
  }
}

Widget errorNotification(){
  return ListTile(
    title: Text('Something went wrong'),
  );
}

Widget userJoinNotification(Map<String, dynamic> notificationData) {
    /* Document fields:
      type: 'userJoin'
      userName: The name of the user joining
      timestamp: The time they joined */
    try {
      return ListTile(
        title: RichText(
          text: TextSpan(
              text: notificationData['userName'],
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: " joined your organization",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ]),
        ),
        subtitle: Text(notificationData['timestamp'].toDate().toString()),
        leading: Icon(Icons.group_add),
      );
    } catch (error) {
      print(error);
      return errorNotification();
    }
  }

  Widget userJoinRequestNotification(Map<String, dynamic> notificationData, BuildContext context){
     /* Document fields:
      type: 'userJoinRequest'
      userName: The name of the user joining
      timestamp: The time they joined */
    try{
      return ListTile(
        title: RichText(
          text: TextSpan(
              text: notificationData['userName'],
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: " wants to join your organization",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ]),
        ),
        subtitle: Text(notificationData['timestamp'].toDate().toString()),
        leading: Icon(Icons.group_add),
        trailing: IconButton(
          icon: Icon(Icons.open_in_new),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageJoinRequestsPage()));
          },
        ),
      );
    }catch(error){
      return errorNotification();
    }
  }

  Widget roleChangeNotification(Map<String, dynamic> notificationData, BuildContext context){
     /* Document fields:
      type: 'roleChange'
      userRole: the user's new role
      callerName: who gave them the new role
      userName: the name of the user who got a new role
      timestamp: the time it occurred */
    try{
      return ListTile(
        title: RichText(
          text: TextSpan(
              text: notificationData['userName'],
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: " was assigned the role ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextSpan(
                  text: notificationData['userRole'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " by ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextSpan(
                  text: notificationData['callerName'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
        ),
        subtitle: Text(notificationData['timestamp'].toDate().toString()),
        leading: Icon(Icons.person_outline_rounded),
        trailing: IconButton(
          icon: Icon(Icons.open_in_new),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageJoinRequestsPage()));
          },
        ),
      );
    }catch(error){
      return errorNotification();
    }
  }
