import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:after_init/after_init.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ManageJoinRequestsPage extends StatefulWidget {
  @override
  _ManageJoinRequestsPageState createState() => _ManageJoinRequestsPageState();
}

class _ManageJoinRequestsPageState extends State<ManageJoinRequestsPage>
    with AfterInitMixin {
  Stream requestStream;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream joinRequestStream(BuildContext context) {
    return _firestore
        .collection('orgs')
        .doc(Provider.of<CurrentOrg>(context).getOrgID())
        .collection('join-requests')
        .snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didInitState() {
    // TODO: implement didInitState
    requestStream = joinRequestStream(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage join requests'),
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: StreamBuilder(
          stream: requestStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              QuerySnapshot querySnapshot = snapshot.data;
              if (querySnapshot.size != 0) {
                return requestTiles(querySnapshot, context);
              } else {
                return Text('No requests :(');
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
                  'orgID': Provider.of<CurrentOrg>(context, listen: false).getOrgID(),
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
            borderRadius: BorderRadius.circular(8.0)
          ),
        ),
      ),
    );
  });
  return ListView(
    children: tiles,
  );
}
