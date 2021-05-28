import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:enrole_app_dev/services/user_data.dart';

class ManageMembersPage extends StatefulWidget {
  @override
  _ManageMembersPageState createState() => _ManageMembersPageState();
}

class _ManageMembersPageState extends State<ManageMembersPage> {

  
  Future<List<Widget>> memberData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memberData = getMemberTiles(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
            return CircularProgressIndicator();
          }
        });
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

  List<Map<dynamic, dynamic>> members = List.generate(membersList.data.length, (index){
    return membersList.data[index];
  });

  print(members);

  members.sort((m1, m2) {
    if (m1['role'] == 'owner') return -1;
    if (m2['role'] == 'owner') return 1;
    var comparison = m1['role'].compareTo(m2['role']);
    if (comparison != 0) {
      if (m1['role'] == 'admin')
        return -1;
      else
        return 1;
    }
    return m1["displayName"].compareTo(m2["displayName"]);
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
