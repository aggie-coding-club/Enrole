import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enrole_app_dev/main.dart';
import 'org_notification_builder.dart';

class OrgNotificationsPage extends StatefulWidget {
  @override
  _OrgNotificationsPageState createState() => _OrgNotificationsPageState();
}

class _OrgNotificationsPageState extends State<OrgNotificationsPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> _orgNotificationSnapshots;

  String _orgID;

  Future<QuerySnapshot> getOrgNotifications(
      BuildContext context, String orgID) async {
    print('Getting notifications...');

    QuerySnapshot query;

    try {
      query = await _firestore
          .collection('orgs')
          .doc(orgID)
          .collection('notifications')
          .orderBy("timestamp", descending: true)
          .limit(10)
          .get();
    } catch (error) {
      print('Getting notificaitons failed. Error: $error');
    }

    print('Got notifications');

    return query;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _orgID = context.read(currentOrgProvider).getOrgID();
      _orgNotificationSnapshots = getOrgNotifications(context, _orgID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _orgNotificationSnapshots,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            QuerySnapshot query = snapshot.data;
            if (query.docs.length == 0) {
              return Text('No notifications');
            }
            return ListView(
              children: notificationBuilder(query),
            );
          } else {
            return Text('No notifications');
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

List<Widget> notificationBuilder(QuerySnapshot querySnapshot) {
  List<Widget> _notificationTiles = [];

  try {
    _notificationTiles = List.generate(querySnapshot.docs.length, (index) {
      return OrgNotificationBuilder(
          notificationData: querySnapshot.docs[index].data());
    });
  } catch (error) {
    print(error);
  }

  return _notificationTiles;
}
