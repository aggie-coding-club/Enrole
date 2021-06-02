// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  String title = 'Error';
  String body = 'Error';
  String author = 'Name';
  String authorProfilePicURL = 'URL';
  // Date timePosted;
  // List<String> seenBy;
  

  Announcement({this.title, this.body, this.author, this.authorProfilePicURL});
}


class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Announcement>> announcementData;

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
            author: documents[index].data()['author'],
            authorProfilePicURL: documents[index].data()['authorProfilePic']
          );
        });
      });

      return announcements;
    } catch (e) {
      print(e);
    }
  }



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

  Widget announcement(String title, String body, String author, String imageURL, int ind) {
    return Row(
        children: <Widget>[
          Flexible(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Expanded_Announcement(index: ind))
                );
              },
              child: Card(
                margin: EdgeInsets.all(15.0),
                child: ExpansionTile(
                    childrenPadding: EdgeInsets.all(10.0), //this is the padding between each announcement tile
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                        image: DecorationImage(
                          image: NetworkImage(imageURL),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(title),
                    children: <Widget>[
                      ListTile(
                        subtitle: Text(
                          body, //trying to use my ExpandableText object expandable_body, but it is not working
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Text(author),
                      ),
                    ]
                ),
              ),
            ),
          ),
        ]
      );
  }


  Widget announcementTilesListView(List<Announcement> announcementsData) {
    List<Widget> announcementTiles =
        List.generate(announcementsData.length, (index) {
      return announcement(announcementsData[index].title, announcementsData[index].body, announcementsData[index].author, announcementsData[index].authorProfilePicURL, index);
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
        }
    );
  }
}

class Expanded_Announcement extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _AnnouncementsState anc_state = new _AnnouncementsState();
  Future<List<Announcement>> announcementData;
  Expanded_Announcement exp_anc;
  int index; //This index variable displays the correct announcement that's clicked on

  Expanded_Announcement({index = 0}) {
    announcementData = anc_state.announcementsData();
    this.index = index;
  }

  @override
  Widget build(BuildContext context) {
    Expanded_Announcement();

    return FutureBuilder(
        future: announcementData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Announcement> announcementData = snapshot.data;
            if (announcementData != null) {
              return expandedAnnouncementView(announcementData, context);
            } else {
              return Text('Sorry, no data :(');
            }
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }

  Widget expandedAnnouncement(String title, String body, String author, String imageURL, BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_left),
        ),
        actions: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
              image: DecorationImage(
                image: NetworkImage(imageURL),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Text(
            body,
            style: TextStyle(fontSize: 22),
          )
        ),
      ),
    );
  }


  Widget expandedAnnouncementView(List<Announcement> announcementsData, BuildContext context) {
    return expandedAnnouncement(announcementsData[index].title, announcementsData[index].body, announcementsData[index].author, announcementsData[index].authorProfilePicURL, context);
  }


}
