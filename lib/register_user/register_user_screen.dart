import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enrole_app_dev/builders/school_search.dart';
import 'package:http/http.dart';

class RegisterUserPage extends StatefulWidget {
  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  FirebaseAuth _auth =
      FirebaseAuth.instance; // Creates FirebaseAuth instance for authentication
  Firestore _firestore =
      Firestore.instance; // Creates Firestore instance for data

  String _email;
  String _password1;
  String _password2;

  RegExp exp = RegExp(r"(\w+\.edu)");

  final _formKey = GlobalKey<FormState>();

  Icon _passwordsMatchIcon;

  void attemptRegistration(List<bool> infoComplete) async {
    // Registers user if information checks out
    if (!infoComplete.contains(false)) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password2);
        final user = await _auth.currentUser();
        await _firestore.collection('users').document(user.uid).setData({
          // Saves the users email and joining date under their profile
          'email': _email,
          'joined': DateTime.now().toString(),
        });
        Navigator.pushNamed(context, '/home'); // Navigates to the home page
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    _email = '';
    _password1 = '';
    _password2 = '';
    _passwordsMatchIcon = Icon(
      Icons.clear,
      color: Colors.red,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Iterable<RegExpMatch> domain = exp.allMatches(_email);

    Future<String> matchingSchoolName;

    if(domain.length ==1){
      print('Search Initiated');
      matchingSchoolName = searchSchools(query: domain.first[0].toString());
    }
    

    List<bool> infoComplete = [
      _email.isNotEmpty,
      _email != null,
      _password1 == _password2,
      _password2 != null,
      _password2.length > 5
    ]; // List of booleans to determine data format is correct

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please input text';
                  }
                  return null;
                },
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _password1 = value;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please input text';
                  }
                  return null;
                },
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _password2 = value;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please input text';
                  }
                  return null;
                },
              ),
              domain.length == 1 ? FutureBuilder(
                future: searchSchools(query: domain.first[0].toString()),
                builder: (context, snapshot){
                  String school = snapshot.data;
                  print('Data: ${snapshot.data}');
                  if(snapshot.connectionState == ConnectionState.done){
                    if(school != null){
                      return Text(school);
                    } else {
                      return Text('No School Found');
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ) : Text('Waiting'),
            ],
          ),
        ),
      ),
    );
  }
}
