import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:enrole_app_dev/services/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'manage_join_requests.dart';
import 'package:enrole_app_dev/builders/hero_dialog_route.dart';

class ManageMembersPage extends StatefulWidget {
  @override
  _ManageMembersPageState createState() => _ManageMembersPageState();
}

class _ManageMembersPageState extends State<ManageMembersPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Widget>>? memberData;

  Future<QuerySnapshot>? _joinRequestDocs;

  String? _orgID;

  Future<QuerySnapshot>? joinRequestDocs(
      BuildContext context, String? _orgID) async {
    return await _firestore
        .collection('orgs')
        .doc(_orgID)
        .collection('join-requests')
        .get();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orgID = context.read(currentOrgProvider).getOrgID();
    memberData = getMemberTiles(context, _orgID);
    _joinRequestDocs = joinRequestDocs(context, _orgID);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final String _orgID = watch(currentOrgProvider).getOrgID();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder(
              future: _joinRequestDocs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                  QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
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
                    if (snapshot.hasData && snapshot.data != null) {
                      List<Widget> tiles = snapshot.data as List<Widget>;
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
    });
  }
}

Future<List<Widget>> getMemberTiles(BuildContext context, String? orgID) async {
  print('Started member query');

  HttpsCallable _getOrgMembers =
      FirebaseFunctions.instance.httpsCallable('getOrgMembers');

  final membersList = await _getOrgMembers.call(<String, dynamic>{
    'orgID': orgID,
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
        Hero(
          tag: members[index]['userID'],
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  HeroDialogRoute(
                      builder: (context) =>
                          AdminProfilePopupCard(members[index], orgID)));
            },
            child: Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(members[index]['userPhotoURL']),
                ),
              ),
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

class AdminProfilePopupCard extends StatefulWidget {
  final Map<dynamic, dynamic> memberProfile;

  final String? orgID;

  AdminProfilePopupCard(this.memberProfile, this.orgID);

  @override
  _AdminProfilePopupCardState createState() => _AdminProfilePopupCardState();
}

class _AdminProfilePopupCardState extends State<AdminProfilePopupCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 140.0, 16.0, 100.0),
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Hero(
              tag: this.widget.memberProfile['userID'],
              child: Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        NetworkImage(this.widget.memberProfile['userPhotoURL']),
                  ),
                  borderRadius: BorderRadius.circular(75.0),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              this.widget.memberProfile['userDisplayName'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 22.0,
              ),
            ),
            Row(
              children: [
                Text(this.widget.memberProfile['userRole']),
                TextButton(
                  onPressed: () {
                    String _dropdownValue =
                        this.widget.memberProfile['userRole'];
                    print(_dropdownValue);
                    showDialog(
                        context: context,
                        builder: (context) =>
                            StatefulBuilder(builder: (context, setState) {
                              return AlertDialog(
                                title: Text('Change member role'),
                                content: DropdownButton(
                                  value: _dropdownValue,
                                  icon: Icon(Icons.arrow_downward_rounded),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _dropdownValue = newValue ?? '';
                                    });
                                  },
                                  items: <String>['member', 'admin', 'owner']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value.toUpperCase()),
                                    );
                                  }).toList(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: _dropdownValue !=
                                            this
                                                .widget
                                                .memberProfile['userRole']
                                        ? () {
                                            HttpsCallable _changeUserRole =
                                                FirebaseFunctions.instance
                                                    .httpsCallable(
                                                        'changeUserRole');
                                            _changeUserRole.call({
                                              'userID': this
                                                  .widget
                                                  .memberProfile['userID'],
                                              'orgID': this.widget.orgID,
                                              'newUserRole': _dropdownValue,
                                            });
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Refresh to see changes'),
                                            ));
                                          }
                                        : null,
                                    child: Text('Confirm'),
                                  ),
                                ],
                              );
                            }));
                  },
                  child: Text('Change role'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
