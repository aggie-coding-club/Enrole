import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserSettingsScaffold extends StatefulWidget {
  @override
  _UserSettingsScaffoldState createState() => _UserSettingsScaffoldState();
}

class _UserSettingsScaffoldState extends State<UserSettingsScaffold> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseStorage _storage = FirebaseStorage.instance;

  Widget getProfileImage() {
    Widget profileImage;

    String userPhotoURL;

    try {
      userPhotoURL = _auth.currentUser.photoURL;

      if (userPhotoURL == null) {
        userPhotoURL =
            "https://t4.ftcdn.net/jpg/02/15/84/43/240_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg";
      }

      profileImage = Container(
        height: 100.0,
        width: 100.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(userPhotoURL),
          ),
        ),
      );

      return profileImage;
    } catch (error) {
      print(error);

      return Text('Could not load profile image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.clear),
          color: Colors.white,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            getProfileImage(),
            ElevatedButton(
              child: Text('Edit profile picture'),
              onPressed: (){},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Email: ${_auth.currentUser.email.toString()}'),
                ElevatedButton(
                  child: Text('Change email'),
                  onPressed: () {},
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Display name: ${_auth.currentUser.displayName.toString()}'),
                ElevatedButton(
                  child: Text('Change display name'),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
