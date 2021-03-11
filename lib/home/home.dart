import 'package:enrole_app_dev/home/home_pages/overview.dart';
import 'package:flutter/material.dart';
import 'home_pages/overview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_pages/register_organization/register_organization.dart';
import 'home_pages/search_orgs/search_orgs.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Widget bodyPage;

  String pageTitle;

  OrgNameIDRole _currentOrg;

  String _role;

  Future<List<OrgNameIDRole>> _orgs;

  Future<String> getRole(String orgID) async {
    String role;
    DocumentSnapshot docData;
    try{
      final user = _auth.currentUser;
      if(user != null){
        await _firestore.collection('orgs').doc(orgID).collection('members').doc(user.uid).get().then((DocumentSnapshot ds) {docData = ds;});
        role = docData.data()['role'];
        return role;
      }
      return 'error';
    }catch(e){print(e); return 'error';}
  }

  Future<List<OrgNameIDRole>> getOrgs() async {
    List<OrgNameIDRole> orgs = [];
    List<DocumentSnapshot> orgListDocs = [];
    String orgName;
    String id;
    try{
      final user = _auth.currentUser;
      if(user != null){
        await _firestore.collection('users').doc(user.uid).collection('orgs').get().then((value) {
          orgListDocs = value.docs;
          print(orgListDocs);
        });
        for(var i = 0; i < orgListDocs.length; i++){
          String orgName = '';
          String role = '';
          await _firestore.collection('orgs').doc(orgListDocs[i].data()['orgID']).get().then((value) {orgName = value.data()['orgName'];});
          print('Got org name');
          await _firestore.collection('orgs').doc(orgListDocs[i].data()['orgID']).collection('members').doc(user.uid).get().then((value) {role = value.data()['role'];});
          print('Got org role');
          final newOrg = OrgNameIDRole(
            id: orgListDocs[i].data()['orgID'],
            name: orgName,
            role: role,
          );
          print('Bout to add this hoe');
          orgs.add(newOrg);
        }
        setState(() {
          _currentOrg = orgs[0];
        });
        return orgs;
    }
      return [OrgNameIDRole(name: 'error', id: 'error', role: 'error')];
    }catch(e){print(e); return [OrgNameIDRole(name: 'error', id: 'error', role: 'error')];}
  }

  Function bodyPageCallback(Widget newPage, String newPageTitle){
    setState(() {
      bodyPage = newPage;
      pageTitle = newPageTitle;
    });
  }

  Function changeOrgCallback(OrgNameIDRole newOrg){
    setState(() {
      _currentOrg = newOrg;
    });
  }

  @override
  void initState() {
    bodyPage = Overview();
    pageTitle = 'Overview';
    _orgs = getOrgs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            pageTitle,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          _currentOrg != null
              ? _currentOrg.role == 'admin'
                ? Container(
            margin: EdgeInsets.all(12.0),
                  child: RaisedButton(
            onPressed: (){},
            child: Text('Admin Console'),
          ),
                )
              : Container() : Container(),
        ],
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).appBarTheme.iconTheme.color),
      ),
      drawer: Drawer(
        child: drawerItems(callback: bodyPageCallback, orgCallback: changeOrgCallback, currentOrg: _currentOrg, orgs: _orgs,),
      ),
      body: bodyPage,
    );
  }
}

class drawerItems extends StatefulWidget {

  final Function callback;
  final Function orgCallback;
  final Widget bodyPage;
  final OrgNameIDRole currentOrg;
  final String userName;
  final Future<List<OrgNameIDRole>> orgs;

  drawerItems({this.callback, this.bodyPage, this.currentOrg, this.orgCallback, this.userName, this.orgs});

  @override
  _drawerItemsState createState() => _drawerItemsState();
}

class _drawerItemsState extends State<drawerItems> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40.0,
                  ),
                  Divider(
                    color: Colors.blueAccent,
                    thickness: 4.0,
                  ),
                  Container(
                    height: 30.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('User 123134')
                        ),
                        SizedBox(width: 15.0,),
                        FutureBuilder(
                          future: this.widget.orgs,
                          builder: (context, snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              List<OrgNameIDRole> orgs = snapshot.data;
                              return DropdownButton(
                                icon: Icon(Icons.arrow_drop_down),
                                value: this.widget.currentOrg,
                                onChanged: (newOrg){
                                  this.widget.orgCallback(newOrg);
                                  Navigator.pop(context);
                                },
                                items: List.generate(orgs.length, (index){
                                  return DropdownMenuItem(
                                    value: orgs[index],
                                    child: Text(orgs[index].name),
                                  );
                                }),
                              );
                            } else {return CircularProgressIndicator();}
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: (){},
                  icon: Icon(Icons.settings),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Home'),
            trailing: Icon(Icons.home),
            onTap: (){
              this.widget.callback(Overview(), 'Overview');
              Navigator.pop(context);
            },
          ),
        ),
        Divider(
          thickness: 2.0,
          color: Colors.grey[200],
        ),
        Card(
          child: ListTile(
            title: Text('Search Orgs'),
            trailing: Icon(Icons.search),
            onTap: (){
              this.widget.callback(SearchOrgs(), 'Search Orgs');
              Navigator.pop(context);
            },
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Register an Organization'),
            trailing: Icon(Icons.add),
            onTap: (){
              this.widget.callback(RegisterOrganizationPage(callback: this.widget.callback,), 'Register');
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

class OrgNameIDRole{
  String name;
  String id;
  String role;
  OrgNameIDRole({this.name, this.id, this.role});
}

