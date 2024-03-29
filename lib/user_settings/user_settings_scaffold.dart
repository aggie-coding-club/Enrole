import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:after_init/after_init.dart';

class UserSettingsScaffold extends StatefulWidget {
  @override
  _UserSettingsScaffoldState createState() => _UserSettingsScaffoldState();
}

class _UserSettingsScaffoldState extends State<UserSettingsScaffold> with AfterInitMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  String userPhotoURL;  
  bool userProfileEdited = false;
  User _user;
  String _userDisplayName;

  Widget getProfileImage(BuildContext context,  User user) {   
  Widget profileImage; 

    try {
      userPhotoURL = user.photoURL;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  void didInitState() {
    // TODO: implement didInitState
    _user = Provider.of<User>(context);
    _userDisplayName = Provider.of<User>(context).displayName;
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
            getProfileImage(context, _user),
            ElevatedButton(
              child: Text('Edit profile picture'),
              onPressed: (){},
            ),
            TextFormField(
              initialValue: _user.displayName,
              onChanged: (value){
                if(value != _user.displayName){
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
              : (){
                if(_formKey.currentState.validate()){
                  _user.updateProfile(
                    displayName: _userDisplayName,
                  );
                  setState(() {
                    userProfileEdited = false;
                  });
                }
              },
              child: Text('Update profile'),
            ),
          ],
        ),
      ),
    );
  }
}
