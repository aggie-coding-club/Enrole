import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  String title;
  String body;

  Announcement({this.title, this.body}) {}
}

class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  //Firebase _firestore variable goes here

  // * announcementData() function goes here which is firebase stuff, which is done by Patrick

  List<Widget> announcementTilesListView(List<Announcement> announcementsData) {
    List<Widget> announcementTiles =
        List.generate(announcementsData.length, (index) {
      return Card(
        child: ListTile(
          title: Text(announcementsData[index].title),
          subtitle: Text(announcementsData[index].body),
        ),
      );
    });
    return ListView(
      children: announcementTiles,
    );
  }

  Future<List<Announcement>> announcementsData;
  void refreshAnnouncements() {
    print(title);
    setState(() {
      announcementsData = announcementData();
    });
  }

  Widget announcement(String title, String body) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(body),
      ),
    );
  }

  Future<String> title;
  @override
  void initState() {
    super.initState();
    announcementsData = announcementData();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            announcementsData, //announcementsData is a list of announcements
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Announcement> announcementData = snapshot.announcementsData();
            if (announcementData != null) {
              return announcementTilesListView(announcementData);
            } else {
              return Text('No announcementsData');
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

Widget announcementTile(String title, String description, String author) {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
  return Card(
      child: ListTile(
    leading: Icon(Icons.announcement_rounded),
    title: Text(title),
    subtitle: Text(description),
    trailing: Text(formattedDate),
  ));
}

// class _AnnouncementsState extends State<Announcements> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(children: [
//       announcementTile(
//           "First announcement!", "This is the first announcement", "Beau"),
//       announcementTile("Gonzaga to the championship!",
//           "Jalen Suggs built different", "Gonzaga"),
//     ]);
//   }
// }
