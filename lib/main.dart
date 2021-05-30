import 'package:enrole_app_dev/home/home.dart';
import 'package:enrole_app_dev/home/home_pages/overview.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'login/login_screen.dart';
import 'register_user/register_user_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:enrole_app_dev/services/user_data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:enrole_app_dev/services/globals.dart';
import 'admin_console/admin_console_scaffold.dart';
import 'admin_console/admin_console_pages/analytics_page/analytics_page.dart';
import 'user_settings/user_settings_scaffold.dart';

void main() {
  runApp(InitApp());
}

class InitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Inistializing Firebase');
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          // TODO: Create a screen from app crash on initialization
          return Text(
            'Something went wrong',
            textDirection: TextDirection.ltr,
          );
        } else if (snapshot.connectionState == ConnectionState.done) {

          FirebaseAuth _auth = FirebaseAuth.instance;

          return MultiProvider(
            child: MyApp(),
            providers: [
              StreamProvider<User>(create: (_) => FirebaseAuth.instance.userChanges(), initialData: null),
              StreamProvider<UserData>(create: (_) => UserDatabaseService().streamUser(_auth.currentUser.uid), initialData: null,),
              StreamProvider<List<JoinedOrg>>(create: (_)=> UserDatabaseService().streamJoinedOrgs(_auth.currentUser.uid), initialData: [],),
              ChangeNotifierProvider<CurrentPage>(create: (_) => CurrentPage(),),
              ChangeNotifierProvider<CurrentOrg>(create: (_) => CurrentOrg(),),
              ChangeNotifierProvider<CurrentAdminPage>(create: (_) => CurrentAdminPage(),),
            ],
          );
        } else {
          // TODO: Create a splash screen
          return Text(
            'Loading',
            textDirection: TextDirection.ltr,
          );
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        canvasColor: Colors.white,
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[700],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.blue[700],
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register-user': (context) => RegisterUserPage(),
        '/home': (context) => Home(),
        '/admin-console': (context) => AdminConsole(),
        '/user-settings': (context) => UserSettingsScaffold(),
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: Global.analytics),
      ],
    );
  }
}

class CurrentOrg with ChangeNotifier{
  JoinedOrg _org;

  get org => _org;

  set org(JoinedOrg org){
    _org = org;
    notifyListeners();
  }

  String getOrgURL (){
    if (_org != null){
      return _org.orgImageURL;
    } else {
      return "https://cdn4.iconfinder.com/data/icons/web-and-mobile-ui/24/UI-33-512.png";
    }
  }

  String getUserRole(){
    if (_org != null){
      return _org.userRole;
    } else {
      return "member";
    }
  }

  String getOrgID(){
    if (_org != null){
      return _org.orgID;
    } else {
      return "Error";
    }
  }

  String getOrgName(){
    if (_org != null){
      return _org.orgName;
    } else {
      return "Error";
    }
  }
}

class CurrentPage with ChangeNotifier {
  Widget _pageWidget = Overview();
  String _pageTitle = 'Join an Org';

  get pageWidget => _pageWidget;

  get pageTitle => _pageTitle;

  set pageWidget(Widget widget){
    _pageWidget = widget;
    notifyListeners();
  }

  set pageTitle(String title){
    _pageTitle = title;
    notifyListeners();
  }
}

class CurrentAdminPage with ChangeNotifier {
  Widget _pageWidget = AnalyticsPage();
  String _pageTitle = 'Analytics';

  get pageWidget => _pageWidget;

  get pageTitle => _pageTitle;

  set pageWidget(Widget widget){
    _pageWidget = widget;
    notifyListeners();
  }

  set pageTitle(String title){
    _pageTitle = title;
    notifyListeners();
  }
}
