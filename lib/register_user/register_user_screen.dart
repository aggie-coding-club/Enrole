import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enrole_app_dev/builders/school_search.dart';
import 'package:enrole_app_dev/builders/match_domain_to_school.dart';
import 'package:http/http.dart';
import 'package:enrole_app_dev/home/home.dart';

class RegisterUserPage extends StatefulWidget {
  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  FirebaseAuth _auth =
      FirebaseAuth.instance; // Creates FirebaseAuth instance for authentication
  FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Creates Firestore instance for data

  String _email;
  String _password1;
  String _password2;

  RegExp exp = RegExp(r"(\w+\.edu)");

  Iterable<RegExpMatch> domain;

  Widget matchedSchool;

  Future<String> matchingSchoolName;

  final _formKey = GlobalKey<FormState>();

  Icon _passwordsMatchIcon;

  void searchForMatchingSchools() {}

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

  void signupUser() async {
    print("Signing up user");
    if (_formKey.currentState.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password2);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: ListView(
              children: [
                SizedBox(height: 50.0,),
                Text(
                  'Register',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0,
                  ),
                ),
                SizedBox(height: 70.0),
                Container(
                  margin: EdgeInsets.all(12.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.email),
                      hintText: 'Enter your email',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                        Iterable<RegExpMatch> domain = exp.allMatches(_email);
                        if (domain.length == 1) {
                          print('Search Initiated');
                          matchingSchoolName = matchDomainToSchool(_email);
                          matchedSchool = matchedSchoolText(matchingSchoolName);
                        } else if (domain.length == 0) {
                          matchedSchool = null;
                          matchingSchoolName = null;
                        }
                      });
                    },
                    validator: (value) {
                      print("Signup With Email: $matchingSchoolName");
                      Iterable<RegExpMatch> domain = exp.allMatches(value);
                      if (value.isEmpty) {
                        return 'Please input text';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(12.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.password),
                      hintText: 'Enter a password',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _password1 = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please input text';
                      }
                      if (value.length <= 6) {
                        return 'Please input a password longer than 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(12.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.refresh),
                      hintText: 'Reenter your password',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _password2 = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please input text';
                      }
                      if (value.length <= 6) {
                        return 'Please input a password longer than 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                Text('School match:'),
                matchedSchool != null
                    ? matchedSchool
                    : Text('No Universities match that domain'),
                    SizedBox(height: 12.0,),
                ElevatedButton(onPressed: signupUser, child: Text('Register here')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget matchedSchoolText(Future<String> matchingSchoolName) {
  return FutureBuilder(
    future: matchingSchoolName,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        String school = snapshot.data;
        print('Data: ${snapshot.data}');
        if (school != null) {
          return Text("Matched School:  $school");
        } else {
          return Text('No Universities match that domain');
        }
      } else {
        return CircularProgressIndicator();
      }
    },
  );
}
