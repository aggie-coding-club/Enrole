import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

Future<String?> matchDomainToSchool(String email) async {
  print('Matching domain to school...');
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RegExp exp = RegExp(r"(\w+\.edu)");
  Iterable<RegExpMatch> matches = exp.allMatches(email);
  String domain = matches.first[0].toString();

  print('Domain is: $domain');

  QuerySnapshot? results;

  await _firestore
      .collection('universities')
      .where("domains", arrayContains: domain)
      .get()
      .then((QuerySnapshot snapshot) {
    results = snapshot;
  });

  if (results != null) {
    if (results == null) {
      return null;
    }
    if (results!.size > 1) {
      return null;
    }
    try {
      return results!.docs.first['name'];
    } catch (e) {
      print(e);
    }
  }

  return null;
}
