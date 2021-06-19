import 'package:enrole_app_dev/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSettingsScaffold extends StatefulWidget {
  @override
  _UserSettingsScaffoldState createState() => _UserSettingsScaffoldState();
}

class _UserSettingsScaffoldState extends State<UserSettingsScaffold> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  String? userPhotoURL;
  bool userProfileEdited = true;
  User? _user;
  String? _userDisplayName;

  Widget getProfileImage(BuildContext context, User user) {
    Widget profileImage;

    try {
      userPhotoURL = user.photoURL ?? 'https://thumbs.dreamstime.com/b/set-question-mark-red-piece-paper-many-marks-white-board-concept-170218759.jpg';

      profileImage = Container(
        height: 100.0,
        width: 100.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(userPhotoURL!),
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
  void initState() {
    // TODO: implement initState
    super.initState();

    _user = context.read(userProvider).data!.value;
    _userDisplayName = _user!.displayName;
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
            Text(_userDisplayName!),
            getProfileImage(context, _user!),
            ElevatedButton(
              child: Text('Edit profile picture'),
              onPressed: () {},
            ),
            TextFormField(
              initialValue: _user!.displayName,
              onChanged: (value) {
                if (value != _user!.displayName) {
                  _userDisplayName = value;
                  setState(() {
                    userProfileEdited = true;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: !userProfileEdited
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        _user!.updateDisplayName(_userDisplayName);
                        setState(() {
                          userProfileEdited = false;
                        });
                      }
                    },
              child: Text('Update profile'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
                _auth.signOut();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
