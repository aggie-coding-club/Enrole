import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> announcementTitle() async {
    String title;

    print('Initiated title');
    try{
      await _firestore
        .collection('debug')
        .doc('documentID')
        .get()
        .then((DocumentSnapshot doc) {
      print('Got here');
      Map<String, dynamic> titleData = doc.data();
      print(titleData);
      title = titleData['title'];
      print(title);
    });
    print(title);
    return title;
    }catch(e){print(e);}
  }
  void refreshAnnouncements() {
    print(title);
    setState(() {
      title = announcementTitle();
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
    // TODO: implement initState
    super.initState();
    title = announcementTitle();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ElevatedButton(
          child: Text('Refresh'),
          onPressed: () {
            refreshAnnouncements();
          },
        ),
        FutureBuilder(
            future: title,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                String title = snapshot.data;
                if (title != null) {
                  return Text(title);
                } else {
                  return Text('Couldnt load it');
                }
              } else {
                return Text('Loading...');
              }
            }),
        announcement('First announcement', 'Come to the meeting!'),
      ],
    );
  }
}
