import 'package:enrole_app_dev/home/home_pages/overview.dart';
import 'package:flutter/material.dart';
import 'home_pages/overview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_pages/register_organization/register_organization.dart';
import 'home_pages/search_orgs/search_orgs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_pages/announcements/announcements.dart';
import 'builders/app_bar_actions.dart';
import 'package:enrole_app_dev/services/user_data.dart';
import 'package:provider/provider.dart';
import 'package:enrole_app_dev/main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Widget bodyPage;

  String pageTitle;

  JoinedOrg _currentOrg;

  String _role;

  Future<List<JoinedOrg>> _orgs;

  String usersSchool;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

//TODO: User provider to constantly monitor and update user data

  Function bodyPageCallback(Widget newPage, String newPageTitle) {
    setState(() {
      bodyPage = newPage;
      pageTitle = newPageTitle;
    });
  }

  Function changeOrgCallback(JoinedOrg newOrg) {
    setState(() {
      _currentOrg = newOrg;
    });
  }

  @override
  void initState() {
    super.initState();
    bodyPage = Overview();
    pageTitle = 'Overview';
    context.read<UserData>();
    context.read<List<JoinedOrg>>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentPage>(
      builder: (_, currentPage, __) => Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            centerTitle: false,
            leading: IconButton(
                icon: Icon(Icons.menu,
                    size: 35.0, color: Theme.of(context).primaryColor),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                }),
            title: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                currentPage.pageTitle,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              _currentOrg != null
                  ? _currentOrg.userRole == 'admin'
                      ? Container(
                          margin: EdgeInsets.all(12.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Admin Console'),
                          ),
                        )
                      : Container()
                  : Container(),
              Container(
                margin: EdgeInsets.fromLTRB(9.0, 0.0, 10.0, 0.0),
                child: Center(
                  child: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 998) {
                        setState(() {
                          var currentPage =
                              Provider.of<CurrentPage>(context, listen: false);
                          currentPage.pageWidget = SearchOrgs();
                          currentPage.pageTitle = 'Search your School\'s Orgs';
                        });
                      }
                      if (value == 999) {
                        setState(() {
                          var currentPage =
                              Provider.of<CurrentPage>(context, listen: false);
                          currentPage.pageWidget = RegisterOrganizationPage();
                          currentPage.pageTitle = 'Register an Organization';
                        });
                      }
                    },
                    padding: EdgeInsets.all(0.0),
                    elevation: 2.0,
                    offset: Offset(50, 50),
                    iconSize: 30.0,
                    icon: Icon(Icons.add_circle_outline_sharp),
                    itemBuilder: (context) {
                      return orgListMenuItems(context);
                    },
                    initialValue: 0,
                  ),
                ),
              ),
            ],
            elevation: 5.0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
                color: Theme.of(context).appBarTheme.iconTheme.color),
          ),
        ),
        drawer: Drawer(
          child: drawerItems(),
        ),
        body: currentPage.pageWidget,
      ),
    );
  }
}

class drawerItems extends StatefulWidget {
  @override
  _drawerItemsState createState() => _drawerItemsState();
}

class _drawerItemsState extends State<drawerItems> {
  FirebaseAuth _auth = FirebaseAuth.instance;

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
                  Container(
                    height: 30.0,
                    child: Row(
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(_auth.currentUser.email)),
                      ],
                    ),
                  ),
                  Text(context.read<UserData>().school),
                ],
              ),
              IconButton(
                onPressed: () {},
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
            title: Text('Overview'),
            trailing: Icon(Icons.home),
            onTap: () {
              Provider.of<CurrentPage>(context);
              Navigator.pop(context);
            },
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Announcements'),
            trailing: Icon(Icons.announcement_outlined),
            onTap: () {
              var currentPage =
                  Provider.of<CurrentPage>(context, listen: false);
              currentPage.pageWidget = Announcements();
              currentPage.pageTitle = 'Announcements';
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
