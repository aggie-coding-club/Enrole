import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class UserDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  JoinedOrg? _currentOrg;

  Stream<UserData> streamUser(String userID) {
    return _firestore
        .collection('users')
        .doc(userID)
        .collection('hidden-data')
        .doc('fixed')
        .snapshots()
        .map((event) => UserData.fromFirestore(event));
  }

  Stream<List<JoinedOrg>> streamJoinedOrgs(String userID) {
    var ref =
        _firestore.collection('users').doc(userID).collection('joined-orgs');

    Stream<List<JoinedOrg>> stream = ref.snapshots().map((QuerySnapshot orgs) =>
        orgs.docs
            .map((DocumentSnapshot document) =>
                JoinedOrg.fromFirestore(document))
            .toList());

    return stream;
  }
}

class Organizations with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<JoinedOrg>? _orgs;
  JoinedOrg? _current;

  Stream<List<JoinedOrg>> streamJoinedOrgs(String userID) {
    var ref =
        _firestore.collection('users').doc(userID).collection('joined-orgs');

    Stream<List<JoinedOrg>> stream = ref.snapshots().map((QuerySnapshot orgs) =>
        orgs.docs
            .map((DocumentSnapshot document) =>
                JoinedOrg.fromFirestore(document))
            .toList());

    return stream;
  }
}

class JoinedOrg {
  final String? orgName;
  final String? orgID;
  final String? userRole;
  final String? orgImageURL;

  JoinedOrg({this.orgName, this.orgID, this.userRole, this.orgImageURL});

  factory JoinedOrg.fromFirestore(DocumentSnapshot document) {
    Map data = document.data() as Map? ?? {};

    return JoinedOrg(
      orgName: data['orgName'] ?? 'Error',
      orgID: data['orgID'] ?? 'Error',
      userRole: data['userRole'] ?? 'Error',
      orgImageURL: data['orgImageURL'] ?? 'Error',
    );
  }
}

class UserData {
  final String? username;
  final String? profileImageURL;
  final String? joinedDate;
  final String? school;

  UserData({this.username, this.profileImageURL, this.joinedDate, this.school});

  factory UserData.fromFirestore(DocumentSnapshot document) {
    Map data = document.data() as Map? ?? {};
    return UserData(
      school: data['school'] ?? 'Error loading school',
    );
  }
}
