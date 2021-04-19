import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:enrole_app_dev/builders/school_search.dart';
import 'package:provider/provider.dart';
import 'package:enrole_app_dev/services/user_data.dart';

class GeneralInfoFormPage extends StatefulWidget {
  final Function setName;
  final Function setType;

  final String orgName;
  final String orgType;
  final String school;

  final Function hidePageControllers;
  final Function showPageControllers;

  GeneralInfoFormPage({
    this.orgName,
    this.orgType,
    this.school,
    this.showPageControllers,
    this.hidePageControllers,
    this.setName,
    this.setType,
  });

  @override
  _GeneralInfoFormPageState createState() => _GeneralInfoFormPageState();
}

class _GeneralInfoFormPageState extends State<GeneralInfoFormPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String orgType;
  String school;
  String schoolSearch;

  TextEditingController categoryController;

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (this.widget.orgName != null) {
      nameController.text = this.widget.orgName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.all(12.0),
          child: Material(
            elevation: 6.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //TODO: Display the user's school in the header
                Container(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Register an organization under: ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(context.read<UserData>().school),
                      SizedBox(height: 12.0),
                      TextField(
                        controller: nameController,
                        maxLength: 30,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (value) {
                          this.widget.setName(value);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              'Apple pie lovers, Engineers anonymous, etc.',
                          labelText: 'Organization Name (Min. 3 characters)',
                          fillColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 90.0,
                        padding: EdgeInsets.all(12.0),
                        child: DropdownButton(
                          value: this.widget.orgType,
                          hint: Text('Organization Type'),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          isExpanded: false,
                          icon: Icon(Icons.keyboard_arrow_down),
                          iconSize: 35.0,
                          underline: Container(),
                          items: [
                            DropdownMenuItem(
                              value: 'public',
                              child: Card(
                                  color: Colors.lightGreen[200],
                                  child: Container(
                                      margin: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Public',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[700]),
                                      ))),
                            ),
                            DropdownMenuItem(
                              value: 'private',
                              child: Card(
                                  color: Colors.lightBlue[200],
                                  child: Container(
                                      margin: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Private',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[700]),
                                      ))),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              orgType = value;
                              this.widget.setType(value);
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          AntDesign.questioncircleo,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          print('Help button pressed');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
