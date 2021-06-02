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
<<<<<<< HEAD
=======
import 'package:cloud_functions/cloud_functions.dart';
import 'package:after_init/after_init.dart';
>>>>>>> 0029a7830a297f7a75eb3e76755c5161b6978674

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterInitMixin {
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
  void didInitState() async {
    // TODO: implement didInitState
    
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Consumer<CurrentPage>(
      builder: (_, currentPage, __) => Scaffold(
=======
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<CurrentOrg>(context, listen: false).org == null &&
          Provider.of<List<JoinedOrg>>(context, listen: false) != null &&
          Provider.of<List<JoinedOrg>>(context, listen: false).isNotEmpty) {
        Provider.of<CurrentOrg>(context, listen: false).org =
            Provider.of<List<JoinedOrg>>(context, listen: false)[0];
      }
    });
    context.watch<List<JoinedOrg>>();
    context.watch<CurrentOrg>();
    context.watch<User>();

    return Consumer3<CurrentPage, CurrentOrg, User>(
      builder: (_, currentPage, currentOrg, currentUser, __) => Scaffold(
>>>>>>> 0029a7830a297f7a75eb3e76755c5161b6978674
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
<<<<<<< HEAD
=======
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // JoinedOrg current = currentOrg.org;
            // print(current.orgName.toString());

            // HttpsCallable _getOrgMembers =
            //     FirebaseFunctions.instance.httpsCallable('getOrgMembers');

            // final members = await _getOrgMembers.call(<String, dynamic>{
            //   'orgID':
            //       Provider.of<CurrentOrg>(context, listen: false).getOrgID(),
            // });

            // print(members.data);
            // print('Done');
            print(currentUser.emailVerified.toString());
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          showUnselectedLabels: false,
          backgroundColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Members",
              icon: Icon(Icons.notifications),
            ),
          ],
        ),
>>>>>>> 0029a7830a297f7a75eb3e76755c5161b6978674
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
                    backgroundImage: NetworkImage(Provider.of<User>(context).photoURL),
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
<<<<<<< HEAD
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings),
=======
              Container(
                height: 30.0,
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(Provider.of<User>(context).displayName)),
                  ],
                ),
>>>>>>> 0029a7830a297f7a75eb3e76755c5161b6978674
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
