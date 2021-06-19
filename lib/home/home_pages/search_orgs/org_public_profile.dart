import 'package:enrole_app_dev/services/user_data.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enrole_app_dev/main.dart';

class OrgPublicProfile extends StatefulWidget {

  final AlgoliaObjectSnapshot? orgData;

  final ImageProvider? image;

  final BuildContext? context;

  OrgPublicProfile({this.orgData, this.image, this.context});

  @override
  _OrgPublicProfileState createState() => _OrgPublicProfileState();
}

class _OrgPublicProfileState extends State<OrgPublicProfile> {

  FirebaseAuth _auth = FirebaseAuth.instance;

  HttpsCallable _joinRequest = FirebaseFunctions.instance.httpsCallable('joinRequest');

  Widget joinTile(String orgType, String orgID, ScopedReader watch){
    String titleString;
//      String subString;
    Color cardColor;
    Color textColor;

    List<JoinedOrg> joinedOrgs = watch(joinedOrgsProvider).data?.value ?? [];
    List<String> orgIDs = List.generate(joinedOrgs.length, (index) {
      if(joinedOrgs[index].orgID == null){
        return '';
      } else {
        return joinedOrgs[index].orgID!;
      }
      
    });

    switch(orgType){
      case 'public':{
        titleString = 'Join';
//          subString = 'Press here to join';
        cardColor = Colors.lightGreen[200]!;
        textColor = Colors.green[800]!;
      } break;
      case 'private':{
        titleString = 'Send join request';
//          subString = 'Press here to request admission';
        cardColor = Colors.lightBlue[200]!;
        textColor = Colors.blue[800]!;
      } break;
      case 'application':{
        titleString = 'Fill out application';
//          subString = 'Press here to fill out application';
        cardColor = Colors.yellow[100]!;
        textColor = Colors.yellow[700]!;
      } break; 
      default: 
      titleString = 'An error occurred';
      cardColor = Colors.grey;
      textColor = Colors.black;
      ;
    }

    if(orgIDs.contains(orgID)){
      titleString = 'Leave';
      cardColor = Colors.red[200]!;
      textColor = Colors.red[800]!;
    }

    return GestureDetector(
      onTap: (){
        print('Join');
        showModalBottomSheet(context: context, builder: (context){
          return Container(
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () async {
                    Navigator.pop(context);
                  String date = DateTime.now().toString();
                    if(this.widget.orgData != null)
                    try {
                      AlgoliaObjectSnapshot orgData = this.widget.orgData!;
                      final user = _auth.currentUser;
                      await _joinRequest.call(<String, dynamic>{
                        'orgType': orgType,
                        'orgID': orgData.data['orgID'],
                        'orgName': orgData.data['orgName'],
                        'userID': user!.uid,
                        'userName': 'Jesse Phipps',
                        'date': date,
                      });
                      print('Finished');
                    }catch(e){print(e);}},
                ),
              ],
            ),
          );
        });
      },
      child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Text(
            titleString,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    TextStyle labelStyle = TextStyle(
      color: Colors.grey[700],
      fontSize: 28.0,
    );

    TextStyle textStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 18.0
    );

    List<Widget> tagTileBuilder(List<dynamic> tags){
      List<Widget> tagTiles = List.generate(tags.length, (tagIndex){
        return Card(
          child: Container(
            padding: EdgeInsets.all(6.0),
            child: Text(
                tags[tagIndex],
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20.0,
              ),
            ),
          ),
        );
      });
      return tagTiles;
    }



    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: false,
              slivers: [
                SliverAppBar(
                  snap: false,
                  floating: false,
                  pinned: false,
                  backgroundColor: Colors.grey[600],
                  elevation: 4.0,
                  collapsedHeight: 154.0,
                  expandedHeight: 230.0,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    titlePadding: EdgeInsets.all(0.0),
                    title: Stack(
                      children: [
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          top: 160.0,
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            color: Colors.grey[700]!.withOpacity(0.6),
                          ),
                        ),
                        Positioned(
                          left: 0.0,
                          bottom: 0.0,
                          right: 0.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 80.0,
                                width: 80.0,
                                margin: EdgeInsets.only(left: 12.0, bottom: 12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: this.widget.image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(height: 10.0,),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        this.widget.orgData!.data['orgName'],
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    background: Image(image: this.widget.image!, fit: BoxFit.cover,),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        height: 50.0,
                        padding: EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 4.0),
                        child: GestureDetector(
                          onTap: (){
                            print('Contact info');
                            showModalBottomSheet(context: context, builder: (context){
                              return Container(color: Colors.white,);
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                'Contact',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              )
                          ),
                        ),
                      ),
                      Container(
                        height: 50.0,
                        padding: EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                        child: Consumer(
                          builder: (context, watch, child) {
                            return joinTile(this.widget.orgData!.data['orgType'], this.widget.orgData!.data['orgID'], watch);
                          }
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            // Icon(AntDesign.instagram, size: 35.0, color: Colors.pink[800],),
                            // SizedBox(width: 12.0,),
                            // Icon(AntDesign.facebook_square, size: 35.0, color: Colors.blue[700],),
                            // SizedBox(width: 12.0,),
                            // Icon(AntDesign.linkedin_square, size: 35.0, color: Colors.blue[800],),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                        child: Text(
                          this.widget.orgData!.data['bio'],
                          style: textStyle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: Wrap(
                          children: tagTileBuilder(this.widget.orgData!.data['tags']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Divider(
                          color: Colors.grey,
                          thickness: 2.0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                        child: Text(
                          'Upcoming events',
                          style: labelStyle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                        height: 140.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              width: 120.0,
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.lightBlue[100],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Fall retreat for everyone asdlkja',
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.0,),
                                  Text('Tue, May 27'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 14.0,
              left: 14.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  color: Colors.grey,
                  icon: Icon(Icons.arrow_back, color: Colors.grey[700],),
                  onPressed: (){Navigator.pop(context);},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
