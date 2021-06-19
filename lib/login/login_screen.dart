import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  FirebaseAuth _auth = FirebaseAuth.instance;  // Creates FirebaseAuth instance for authentication

  String _email = '';
  String _password = '';

  void attemptLogin(String email, String password) async {  // Logs user in if data checks out
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamed(context, '/home');  // Navigates to home page if sign in is successful
    }catch(e){print(e);}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(  // Email input
                expands: false,
                onChanged: (value){
                  setState(() {
                    _email = value;
                  });
                },
              ),
              SizedBox(  // Spacing
                height: 15.0,
              ),
              TextField(  // Password input
                expands: false,
                onChanged: (value){
                  setState(() {
                    _password = value;
                  });
                },
              ),
              GestureDetector(  // Initiates when widgets inside are tapped
                onTap: (){
                  attemptLogin( _email, _password);  // Attempts to log the user in
                },
                child: Container(
                  margin: EdgeInsets.all(30.0),
                  padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 28.0,)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/register-user');
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New? Register here',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 28.0,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
