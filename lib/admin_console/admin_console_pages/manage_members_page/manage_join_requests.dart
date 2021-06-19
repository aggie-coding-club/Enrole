import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ManageJoinRequestsPage extends StatefulWidget {
  @override
  _ManageJoinRequestsPageState createState() => _ManageJoinRequestsPageState();
}

class _ManageJoinRequestsPageState extends State<ManageJoinRequestsPage> {
  Stream? requestStream;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream joinRequestStream(BuildContext context) {
    final _orgID = context.read(currentOrgProvider).getOrgID();

    return _firestore
        .collection('orgs')
        .doc(_orgID)
        .collection('join-requests')
        .snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestStream = joinRequestStream(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage join requests'),
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: StreamBuilder(
          stream: requestStream,
          builder: (context, snapshot) {
            var snapData = snapshot.data;
            if (snapshot.connectionState == ConnectionState.active &&
                snapData != null) {
              QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
              if (querySnapshot.size != 0) {
                return requestTiles(querySnapshot, context);
              } else {
                return Center(child: Text('No active join requests'));
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}

Widget requestTiles(QuerySnapshot querySnapshot, BuildContext context) {
  HttpsCallable _acceptRequest =
      FirebaseFunctions.instance.httpsCallable('acceptJoinRequest');

  String _orgID = context.read(currentOrgProvider).getOrgID();

  List<Widget> tiles = List.generate(querySnapshot.size, (index) {
    return Card(
      child: ListTile(
        title: Text(querySnapshot.docs[index]['userName']),
        subtitle: Row(
          children: [
            IconButton(
              icon: Icon(Icons.check),
              color: Colors.green,
              onPressed: () {
                _acceptRequest.call(<String, dynamic>{
                  'userID': querySnapshot.docs[index]['userID'],
                  'orgID': _orgID,
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.clear),
              color: Colors.red,
              onPressed: () {},
            ),
          ],
        ),
        leading: Container(
          height: 55.0,
          width: 55.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(querySnapshot.docs[index]['userPhotoURL']),
              ),
              borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  });
  return ListView(
    children: tiles,
  );
}
