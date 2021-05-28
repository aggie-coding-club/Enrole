import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:enrole_app_dev/home/home_pages/overview.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:cloud_functions/cloud_functions.dart';

class VerifyPage extends StatefulWidget {
  final Function homeCallback;

  final String orgName;
  final String orgType;
  final String school;
  final File imageFile;
  final String bio;
  final List<String> tags;

  VerifyPage(
      {this.homeCallback,
      this.orgName,
      this.orgType,
      this.school,
      this.imageFile,
      this.bio,
      this.tags});
  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseStorage _storage = FirebaseStorage.instance;

  var uuid = Uuid();

  Future<Widget> emailVerifiedWidget;

  bool isEmailVerifiedVar = false;

  bool publishing = false;

  Future<Widget> isEmailVerified(BuildContext context) async {
    try{
      final user = _auth.currentUser;
    if(user.emailVerified){
      setState(() {
        isEmailVerifiedVar = true;
      });
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.check, color: Colors.green,),
            SizedBox(width: 4.0,),
            Text('Your email is verified'),
          ],
        ),
      );
    } else{
      setState(() {
        isEmailVerifiedVar = false;
      });
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.clear, color: Colors.red,),
            SizedBox(width: 4.0,),
            Container(
              child: Text('Your email is not verified'),
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor,),
              onPressed: (){
                print('test ${this.widget.school}');
                setState(() {
                  emailVerifiedWidget = isEmailVerified(context);
                });
              },
            ),
            ElevatedButton(
              child: Text('Verify'),
              onPressed: (){
                user.sendEmailVerification();
              },
            ),
          ],
        ),
      );
    }
  }

  void publishOrgToFirestore({String orgName, String orgType, String school, File image, String bio, List<String> tags}) async {
    try{
      print('Creating org...');
      HttpsCallable createOrg = FirebaseFunctions.instance.httpsCallable('createOrg');
      print('Got callable...');
      //TODO: Make sure created organization can't override an existing one
      String orgID = uuid.v4().substring(0, 8);
      final user = _auth.currentUser;
      if(user != null){
        await _storage.ref().child('orgs/$orgID/profileImage').putFile(image);
        final profileImage = await _storage
            .ref()
            .child('orgs/$orgID/profileImage')
            .getDownloadURL();
        final profileImageURL = profileImage.toString();
        print('Got here...');
        await createOrg.call(<String, dynamic>{
          'orgName': orgName,
          'orgType': orgType,
          'school': school,
          'profileImageURL': profileImageURL,
          'bio': bio,
          'tags': tags,
          'owner': user.uid,
          'orgID': orgID,
          'time': DateTime.now().toString(),
        });
        print('Invoked callable');
        // await _firestore.collection('orgs').doc(orgID).set({
        //   'orgName': orgName,
        //   'orgType': orgType,
        //   'school': school,
        //   'profileImageURL': profileImageURL,
        //   'bio': bio,
        //   'tags': tags,
        //   'owner': user.uid,
        //   'orgID': orgID,
        // });
        // await _firestore.collection('orgs').doc(orgID).collection('members').doc(user.uid).set({
        //   'userID': user.uid,
        //   'role': 'admin',
        //   'joined': DateTime.now(),
        // });
        // await _firestore.collection('users').doc(user.uid).collection('joinedOrgs').doc(orgID).set({
        //   'orgName': orgName,
        //   'orgImageURL': profileImageURL,
        //   'orgID': orgID,
        //   'userRole': 'admin',
        // });
        var currentPage = Provider.of<CurrentPage>(context, listen: false);
        currentPage.pageWidget = Overview();
        currentPage.pageTitle = 'Overview';
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    emailVerifiedWidget = isEmailVerified(context);
    publishing = false;
  }

  @override
  Widget build(BuildContext context) {
    bool isNameDone =
        this.widget.orgName != null && this.widget.orgName.length >= 3;
    bool isTypeDone = this.widget.orgType != null;
    bool isSchoolDone = this.widget.school != null;

    bool isImageDone = this.widget.imageFile != null;
    bool isBioDone = this.widget.bio != null;
    bool isTagsDone = this.widget.tags.isNotEmpty;

    List<bool> generalInfoComplete = [isNameDone, isTypeDone, isSchoolDone];
    List<bool> profileInfoComplete = [isImageDone, isBioDone, isTagsDone];

    List<bool> isEverythingVerified = [
      isEmailVerifiedVar,
      !generalInfoComplete.contains(false),
      !profileInfoComplete.contains(false),
    ];

    TextStyle _labelTextStyle = TextStyle(
      fontSize: 20.0,
      color: Theme.of(context).primaryColor,
      letterSpacing: 0.3,
      fontWeight: FontWeight.bold,
    );

    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(12.0),
          child: Material(
            elevation: 6.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(12.0),
                  child: Text(
                    'Verify email',
                    style: _labelTextStyle,
                  ),
                ),
                FutureBuilder(
                  future: emailVerifiedWidget,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data != null
                          ? snapshot.data
                          : Container(
                              margin: EdgeInsets.all(12.0),
                              child: Text('Something went wrong'));
                    } else {
                      return Container(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                Container(
                  margin: EdgeInsets.all(12.0),
                  child: Text(
                    'Entries complete',
                    style: _labelTextStyle,
                  ),
                ),
                generalInfoComplete.contains(false)
                    ? Container(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text('General info is not complete'),
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text('General info is complete'),
                          ],
                        ),
                      ),
                profileInfoComplete.contains(false)
                    ? Container(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text('Profile info is not complete'),
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text('Profile info is complete'),
                          ],
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.0),
                      child: publishing == false
                          ? ElevatedButton(
                              onPressed: isEverythingVerified.contains(false)
                                  ? null
                                  : () {
                                      setState(() {
                                        publishing = true;
                                      });
                                      publishOrgToFirestore(
                                        orgName: this.widget.orgName,
                                        orgType: this.widget.orgType,
                                        school: this.widget.school,
                                        image: this.widget.imageFile,
                                        bio: this.widget.bio,
                                        tags: this.widget.tags,
                                      );
                                    },
                              child: Text('Register!'),
                            )
                          : CircularProgressIndicator(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
}