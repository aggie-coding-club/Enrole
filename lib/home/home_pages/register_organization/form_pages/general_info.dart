import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:enrole_app_dev/builders/school_search.dart';
import 'package:provider/provider.dart';
import 'package:enrole_app_dev/services/user_data.dart';

class GeneralInfoFormPage extends StatefulWidget {
  final Function setName;
  final Function setType;
  final Function setSchool;

  final String orgName;
  final String orgType;
  final String school;

  final Function hidePageControllers;
  final Function showPageControllers;

  GeneralInfoFormPage(
      {this.orgName,
      this.orgType,
      this.school,
      this.showPageControllers,
      this.hidePageControllers,
      this.setName,
      this.setType,
      this.setSchool});

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
                            DropdownMenuItem(
                              value: 'application',
                              child: Card(
                                  color: Colors.yellow[100],
                                  child: Container(
                                      margin: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Application',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow[700]),
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
                this.widget.school == null
                    ? Column(
                        children: [
                          schoolSearch != null && schoolSearch != ''
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: FutureBuilder(
                                        future:
                                            searchSchools(query: schoolSearch),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData) {
                                            List<String> schools =
                                                snapshot.data;
                                            List<Widget> results =
                                                List<Widget>.generate(
                                                    schools.length <= 7
                                                        ? schools.length
                                                        : 7, (index) {
                                              return Card(
                                                child: ListTile(
                                                  title: Text(schools[index]),
                                                  onTap: () {
                                                    setState(() {
                                                      school = schools[index];
                                                      print(school);
                                                      this
                                                          .widget
                                                          .setSchool(school);
                                                      FocusScopeNode
                                                          currentFocus =
                                                          FocusScope.of(
                                                              context);
                                                      if (!currentFocus
                                                          .hasPrimaryFocus) {
                                                        currentFocus.unfocus();
                                                      }
                                                    });
                                                  },
                                                ),
                                              );
                                            });
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: results,
                                            );
                                          } else {
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      )
                    : Container(
                        margin: EdgeInsets.all(12.0),
                        child: Card(
                          elevation: 3.0,
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  school = null;
                                  schoolSearch = null;
                                  this.widget.setSchool(null);
                                });
                              },
                            ),
                            title: Text(this.widget.school),
                          ),
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
