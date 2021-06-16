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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'admin_floating_action_button/admin_floating_action_button.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  String usersSchool;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void reloadUser() async {
    User initUser = _auth.currentUser;
    await initUser.reload();
    print('Reloaded user');
  }

//TODO: User provider to constantly monitor and update user data

  @override
  void initState() {
    super.initState();
    reloadUser();
  }


  @override
  Widget build(BuildContext context) {
    print('Started build...');
    return Scaffold(
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
              onPressed: () async {
                if(_auth.currentUser.displayName == null){
                  await _auth.currentUser.reload();
                }
                _scaffoldKey.currentState.openDrawer();
              }),
          title: FittedBox(
            fit: BoxFit.contain,
            child: Consumer(builder: (context, watch, _) {
              print('Building page consumer...');
              final page = watch(currentPageProvider);
              return Text(
                page.pageTitle,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ),
          actions: [
            Consumer(
              builder: (context, watch, _) {
                print('Building action consumer...');
                final _currentOrg = watch(currentOrgProvider);
                final _currentAdminPage = watch(currentAdminPageProvider);
                if(_currentOrg == null || _currentAdminPage == null)
                  return Container();
                print('Providers called successfully');
                if (_currentOrg.getUserRole() == 'admin' || _currentOrg.getUserRole() == 'owner') {
                  return Container(
                    margin: EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _currentAdminPage.pageWidget = AnalyticsPage();
                        Navigator.pushNamed(context, '/admin-console');
                      },
                      child: Text('Admin'),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            Container(
              margin: EdgeInsets.fromLTRB(9.0, 0.0, 10.0, 0.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                  child: Consumer(builder: (context, watch, _) {
                    final _currentOrg = watch(currentOrgProvider);
                    return _currentOrg.org == null
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
                                image: NetworkImage(_currentOrg.getOrgURL()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                  }),
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
          child: Consumer(
            builder: (context, watch, child) {
              return orgEndDrawer();
            }
          ),
        ),
      ),
      body: Consumer(
        builder: (context, watch, _) {
          print('Huh');
          final _page = watch(currentPageProvider);
          print(_page.toString());
          return _page.pageWidget;
        },
      ),
      floatingActionButton: Consumer(builder: (context, watch, _) {
        final _page = watch(currentPageProvider);
        return Visibility(
          visible: _page.tag != 'registerOrg' && _page.tag != 'searchByID',
          child: AdminFloatingActionButton(),
        );
      }),
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
    );
  }
}

class DrawerItems extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    print('Started watching providers...');
    final _currentOrg = watch(currentOrgProvider);
    final _currentUser = watch(userProvider);
    final _currentPage = watch(currentPageProvider);
    final _userData = watch(userDataProvider);
    print('Finished watching providers');
    return _currentUser.when(
      loading: ()=>CircularProgressIndicator(),
      error: (error, _)=>Text('There was an error'),
      data: (value) {
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
                      backgroundImage:
                          NetworkImage(value.photoURL ?? "https://img.icons8.com/cotton/2x/gender-neutral-user--v2.png"),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    TextButton(
                      onPressed: () {
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
                          child: Text(value.displayName ?? 'Error loading displayName')),
                    ],
                  ),
                ),
                _userData.when(
                  loading: ()=>Text('Loading...'),
                  error: (error, _)=>Text('There was an error getting your school'),
                  data: (value)=>Text(value.school),
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
                _currentPage.pageWidget = Overview();
                _currentPage.pageTitle = 'Overview';
                Navigator.pop(context);
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Announcements'),
              trailing: Icon(Icons.announcement_outlined),
              onTap: () {
                _currentPage.pageWidget = Announcements();
                _currentPage.pageTitle = 'Announcements';
                Navigator.pop(context);
              },
            ),
          ),
        ],
      );
    });
  }
}
