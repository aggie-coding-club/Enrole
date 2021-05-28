/*import 'package:cloud_firestore/cloud_firestore.dart';
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

  Widget announcement(String title, String body) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(body),
      ),
    );
  }

  Widget announcementTilesListView(List<Announcement> announcementsData) {
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
  }
}
*/

import 'package:flutter/material.dart';

class Announcements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: uploadPage(),
      ),
    );
  }

  Widget uploadPage() {
    return ListView(
      children: [
        _appBar(),
        _text(),
        Spacer(),
        _postButton(),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('New Announcement'),
    );
  }

  Widget _text() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0)
                ),
                hintText: 'Title of Announcement...',
                labelText: 'Subject',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              maxLines: 15,
              minLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0)
                ),
                hintText: 'Body of Announcement...',
                labelText: 'Description',
              ),
            ),
          ),
        ]
      );
  }

  Widget _postButton() {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        child: Text('Post'),
        onPressed: () {},
      ),
    );
  }
}
