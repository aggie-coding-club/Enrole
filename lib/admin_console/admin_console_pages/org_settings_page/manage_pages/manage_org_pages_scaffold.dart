import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:enrole_app_dev/main.dart';

class ManageOrgPages extends StatefulWidget {
  @override
  _ManageOrgPagesState createState() => _ManageOrgPagesState();
}

class _ManageOrgPagesState extends State<ManageOrgPages> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> activePagesData;

  
  

  Future<List<String>> getActivePages() async {
    try {
      QuerySnapshot query = await _firestore
          .collection('orgs')
          .doc(Provider.of<CurrentOrg>(context, listen: false).getOrgID())
          .collection('pages')
          .get();

      List<String> pageNameArray = [];

      pageNameArray = List.generate(query.docs.length, (index) {
        return query.docs[index].id;
      });
      return pageNameArray;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activePagesData = getActivePages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage pages'),
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.clear),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: [
          PageTile("Announcements", Icon(Icons.announcement)),
          PageTile("Events", Icon(Icons.event)),
          PageTile("Social Points", Icon(Icons.check)),
          PageTile("Dues", Icon(Icons.money)),
          PageTile("Meetings", Icon(Icons.meeting_room_outlined)),
          PageTile("Assassins", Icon(Icons.group_outlined)),
        ],
      ),
    );
  }
}

class PageTile extends StatefulWidget {

  final String page;

  final Widget leading;

  PageTile(this.page, this.leading);

  @override
  _PageTileState createState() => _PageTileState();
}

class _PageTileState extends State<PageTile> {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void activatePage(String page, BuildContext context) async {
    try {
      await _firestore
          .collection('orgs')
          .doc(Provider.of<CurrentOrg>(context, listen: false).getOrgID())
          .collection('pages')
          .doc(page)
          .get()
          .then((DocumentSnapshot document) async {
        if (!document.exists) {
          await _firestore
              .collection('orgs')
              .doc(Provider.of<CurrentOrg>(context, listen: false).getOrgID())
              .collection('pages')
              .doc(page)
              .set({
            'title': page,
          });
        }
      });
    } catch (error) {
      print(error);
    }
  }

  void deactivatePage(String page, BuildContext context) async {
    try {
      await _firestore
          .collection('orgs')
          .doc(Provider.of<CurrentOrg>(context, listen: false).getOrgID())
          .collection('pages')
          .doc(page)
          .get()
          .then((DocumentSnapshot document) async {
        if (document.exists) {
          await _firestore
              .collection('orgs')
              .doc(Provider.of<CurrentOrg>(context, listen: false).getOrgID())
              .collection('pages')
              .doc(page)
              .delete();
        }
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('orgs').doc(Provider.of<CurrentOrg>(context).getOrgID()).collection('pages').doc(this.widget.page).snapshots(),
      builder: (_, stream){

        print(stream.connectionState.toString());

        if(stream.connectionState == ConnectionState.active){

          print('Snapshot done');

          DocumentSnapshot doc = stream.data;

          bool active = false;

          if(doc.exists){
            active = true;
          }

          return Card(
            child: ListTile(
              title: Text(this.widget.page),
              leading: this.widget.leading,
              trailing: active
              ? ElevatedButton(
                child: Text('Deactivate'),
                onPressed: (){
                  deactivatePage(this.widget.page, context);
                },
              )
              : ElevatedButton(
                child: Text('Activate'),
                onPressed: (){
                  activatePage(this.widget.page, context);
                },
              )
            ),
          );
        } else {
          return Card(
            child: ListTile(
              title: Text(this.widget.page),
              leading: this.widget.leading,
              trailing: CircularProgressIndicator(),
            ),
          );
        }
      }
    );
  }
}
