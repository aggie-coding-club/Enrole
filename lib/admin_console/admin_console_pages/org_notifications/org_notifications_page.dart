import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:after_init/after_init.dart';
import 'org_notification_builder.dart';


class OrgNotificationsPage extends StatefulWidget {
  @override
  _OrgNotificationsPageState createState() => _OrgNotificationsPageState();
}

class _OrgNotificationsPageState extends State<OrgNotificationsPage> with AfterInitMixin {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> _orgNotificationSnapshots;

  Future<QuerySnapshot> getOrgNotifications (BuildContext context) async {
    print('Getting notifications...');


    QuerySnapshot query;
    
    try{
      query = await _firestore.collection('orgs').doc(Provider.of<CurrentOrg>(context).getOrgID()).collection('notifications').orderBy("timestamp", descending: true).limit(10).get();
    }catch(error){print('Getting notificaitons failed. Error: $error');}

    print('Got notifications');

    return query;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didInitState() {
    // TODO: implement didInitState
    _orgNotificationSnapshots = getOrgNotifications(context);
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _orgNotificationSnapshots,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            QuerySnapshot query = snapshot.data;
            if(query.docs.length == 0){
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

List<Widget> notificationBuilder(QuerySnapshot querySnapshot){

  List<Widget> _notificationTiles = [];
  
  try{
    _notificationTiles = List.generate(querySnapshot.docs.length, (index){
      return OrgNotificationBuilder(notificationData: querySnapshot.docs[index].data());
    });
  }catch(error){print(error);}

  return _notificationTiles;
}