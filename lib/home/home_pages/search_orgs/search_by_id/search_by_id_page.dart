import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enrole_app_dev/home/home_pages/search_orgs/org_public_profile.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enrole_app_dev/main.dart';

class SearchByIDPage extends StatefulWidget {
  @override
  _SearchByIDPageState createState() => _SearchByIDPageState();
}

class _SearchByIDPageState extends State<SearchByIDPage>{

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _searchQuery = '';

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget bodyWidget = Container();

  HttpsCallable _joinRequest = FirebaseFunctions.instance.httpsCallable('joinRequest');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      if(context.read(currentPageProvider).tag != 'searchByID'){
          context.read(currentPageProvider).tag = 'searchByID';
        }
    });
  }

  @override
  Widget build(BuildContext context) {

    
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            onChanged: (value){
              setState(() {
                _searchQuery = value;
              });
            },
            validator: (value){
              if(value!.length != 8){
                return 'Please enter a valid ID';
              } else {
                return null;
              }
            },
          ),
          SizedBox(height: 20.0,),
          ElevatedButton(
            child: Text('Search'),
            onPressed: () async {
              print(context.read(currentPageProvider).tag);
              DocumentSnapshot orgDoc = await _firestore.collection('orgs').doc(_searchQuery).get();
              if(orgDoc.exists && orgDoc.data() != null){
                setState(() {
                  Map<String, dynamic> orgDocData = orgDoc.data() as Map<String, dynamic>;
                  bodyWidget = ListTile(
                    title: Text(orgDocData['orgName']),
                    trailing: ElevatedButton(
                      child: Text('Join'),
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          
                          await _joinRequest.call(<String, dynamic>{
                        'orgID': orgDocData['orgID'],
                      });
                        }
                      },
                    ),
                  );
                });
              }
            },
          ),
          bodyWidget,
        ],
      ),
    );
  }
}
