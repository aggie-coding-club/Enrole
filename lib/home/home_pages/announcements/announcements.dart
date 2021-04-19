import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  String title = 'Error';
  String body = 'Error';

  Announcement({this.title, this.body});
}

class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Announcement>> announcementsData() async {
    List<Announcement> announcements;

    print('Initiated title');
    try {
      await _firestore
          .collection('debug')
          .doc('bkta2817')
          .collection('announcements')
          .get()
          .then((QuerySnapshot querySnapshot) {
        List<DocumentSnapshot> documents = querySnapshot.docs;
        announcements = List.generate(documents.length, (index) {
          return Announcement(
            title: documents[index].data()['title'],
            body: documents[index].data()['body'],
          );
        });
      });

      return announcements;
    } catch (e) {
      print(e);
    }
  }

  Future<List<Announcement>> announcementData;

  void refreshAnnouncements() {
    print(title);
    setState(() {
      announcementData = announcementsData();
    });
  }

  Future<String> title;

  @override
  void initState() {
    super.initState();
    announcementData = announcementsData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: announcementData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Announcement> announcementData = snapshot.data;
            if (announcementData != null) {
              return announcementTilesListView(announcementData);
            } else {
              return Text('Sorry, no data :(');
            }
          } else {
            return CircularProgressIndicator();
          }
        });
