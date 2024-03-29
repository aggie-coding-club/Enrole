import 'package:enrole_app_dev/admin_console/admin_console_pages/analytics_page/analytics_page.dart';
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
import 'package:cloud_functions/cloud_functions.dart';
import 'package:after_init/after_init.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterInitMixin {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Widget bodyPage;

  String pageTitle;

  String usersSchool;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

//TODO: User provider to constantly monitor and update user data

  @override
  void initState() {
    super.initState();
    bodyPage = Overview();
    pageTitle = 'Overview';
    context.read<UserData>();
  }

  @override
  void didInitState() async {
    // TODO: implement didInitState
    
  }

  @override
  Widget build(BuildContext context) {
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
              Provider.of<CurrentOrg>(context).org != null
                  ? Provider.of<CurrentOrg>(context).getUserRole() == "admin" ||
                          Provider.of<CurrentOrg>(context).getUserRole() ==
                              "owner"
                      ? Container(
                          margin: EdgeInsets.all(12.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Provider.of<CurrentAdminPage>(context, listen: false).pageWidget = AnalyticsPage();
                              Navigator.pushNamed(context, '/admin-console');
                            },
                            child: Text('Admin'),
                          ),
                        )
                      : Container()
                  : Container(),
              Container(
                margin: EdgeInsets.fromLTRB(9.0, 0.0, 10.0, 0.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                    child: Provider.of<CurrentOrg>(context).org == null
                        ? Icon(
                            Icons.add_box_outlined,
                            size: 40.0,
                            color: Theme.of(context).primaryColor,
                          )
                        : Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                    Provider.of<CurrentOrg>(context)
                                        .getOrgURL()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
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
          child: DrawerItems(),
        ),
        endDrawer: Drawer(
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: orgPanelTiles(context),
            ),
          ),
        ),
        body: currentPage.pageWidget,
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
      ),
    );
  }
}

class DrawerItems extends StatefulWidget {
  @override
  _DrawerItemsState createState() => _DrawerItemsState();
}

class _DrawerItemsState extends State<DrawerItems> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage(Provider.of<User>(context).photoURL),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('/user-settings');
                    },
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 30.0,
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(Provider.of<User>(context).displayName)),
                  ],
                ),
              ),
              Text(context.read<UserData>().school),
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
              var currentPage =
                  Provider.of<CurrentPage>(context, listen: false);
              currentPage.pageWidget = Overview();
              currentPage.pageTitle = 'Overview';
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
