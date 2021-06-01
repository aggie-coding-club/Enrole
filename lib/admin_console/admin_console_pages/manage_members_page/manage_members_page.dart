import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:enrole_app_dev/services/user_data.dart';
import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'manage_join_requests.dart';

class ManageMembersPage extends StatefulWidget {
  @override
  _ManageMembersPageState createState() => _ManageMembersPageState();
}

class _ManageMembersPageState extends State<ManageMembersPage>
    with AfterInitMixin {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Widget>> memberData;

  Future<QuerySnapshot> _joinRequestDocs;

  Future<QuerySnapshot> joinRequestDocs(BuildContext context) async {
    return await _firestore
        .collection('orgs')
        .doc(Provider.of<CurrentOrg>(context).getOrgID())
        .collection('join-requests')
        .get();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didInitState() {
    // TODO: implement didInitState
    memberData = getMemberTiles(context);
    _joinRequestDocs = joinRequestDocs(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder(
            future: _joinRequestDocs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                QuerySnapshot querySnapshot = snapshot.data;
                return joinRequests(querySnapshot, context);
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: null, child: Text('Loading...'))
                  ],
                );
              }
            }),
        Expanded(
          child: FutureBuilder(
              future: memberData,
              builder: (con, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<Widget> tiles = snapshot.data;
                    return GridView.count(
                      primary: false,
                      crossAxisCount: 2,
                      children: tiles,
                    );
                  } else {
                    return Text('Something went wrong');
                  }
                } else {
                  return Column(children: [
                    Container(
                      child: CircularProgressIndicator(),
                      width: 50.0,
                      height: 50.0,
                    ),
                  ]);
                }
              }),
        ),
      ],
    );
  }
}

Future<List<Widget>> getMemberTiles(BuildContext context) async {
  print('Started member query');

  HttpsCallable _getOrgMembers =
      FirebaseFunctions.instance.httpsCallable('getOrgMembers');

  final membersList = await _getOrgMembers.call(<String, dynamic>{
    'orgID': Provider.of<CurrentOrg>(context, listen: false).getOrgID(),
  });

  print('Called cloud function');

  print(membersList.data.length);

  Map test = membersList.data[0];

  print(test);

  List<Map<dynamic, dynamic>> members =
      List.generate(membersList.data.length, (index) {
    return membersList.data[index];
  });

  print(members);

  members.sort((m1, m2) {
    if (m1['userRole'] == 'owner') return -1;
    if (m2['userRole'] == 'owner') return 1;
    var comparison = m1['userRole'].compareTo(m2['userRole']);
    if (comparison != 0) {
      if (m1['userRole'] == 'admin')
        return -1;
      else
        return 1;
    }
    return m1["userDisplayName"].compareTo(m2["userDisplayName"]);
  });

  print('Sorted members');

  List<Widget> memberTiles = List.generate(members.length, (index) {
    return Column(
      children: [
        Container(
          height: 100.0,
          width: 100.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(members[index]['userPhotoURL']),
            ),
          ),
        ),
        Text(members[index]['userDisplayName']),
        Text(members[index]['userRole']),
      ],
    );
  });

  print('Generated tiles');

  return memberTiles;
}

Widget joinRequests(QuerySnapshot querySnapshot, BuildContext context) {
  if (querySnapshot.size == 0) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [TextButton(onPressed: null, child: Text('No requests'))],
    );
  } else {
    String text = '(${querySnapshot.size}) requests';

    if (querySnapshot.size == 1) {
      text = '(${querySnapshot.size}) request';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ManageJoinRequestsPage()));
          },
          child: Text(text),
        )
      ],
    );
  }
}
