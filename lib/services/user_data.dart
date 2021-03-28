import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<UserData> streamUser(String userID) {
    return _firestore
        .collection('users')
        .doc(userID)
        .snapshots()
        .map((event) => UserData.fromFirestore(event));
  }

  Stream<List<JoinedOrg>> streamJoinedOrgs(String userID) {
    var ref =
        _firestore.collection('users').doc(userID).collection('joinedOrgs');

    return ref.snapshots().map((QuerySnapshot orgs) => orgs.docs
        .map((DocumentSnapshot document) => JoinedOrg.fromFirestore(document))
        .toList());
  }
}

class JoinedOrg {
  final String orgName;
  final String orgID;
  final String userRole;
  final String orgImageURL;

  JoinedOrg({this.orgName, this.orgID, this.userRole, this.orgImageURL});

  factory JoinedOrg.fromFirestore(DocumentSnapshot document) {
    Map data = document.data() ?? {};

    return JoinedOrg(
      orgName: data['orgName'] ?? 'Error',
      orgID: data['orgID'] ?? 'Error',
      userRole: data['userRole'] ?? 'Error',
      orgImageURL: data['orgImageURL'] ?? 'Error',
    );
  }
}

class UserData {
  final String username;
  final String profileImageURL;
  final String joinedDate;
  final String school;

  UserData({this.username, this.profileImageURL, this.joinedDate, this.school});

  factory UserData.fromFirestore(DocumentSnapshot document) {
    Map data = document.data() ?? {};
    return UserData(
      username: data['username'] ?? "Unnamed User",
      profileImageURL: data['profileImageURL'] ??
          "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png",
      joinedDate: data['joinedDate'] ?? DateTime.now().toString(),
      school: data['school'],
    );
  }
}
