

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enrole_app_dev/home/home.dart';
import 'package:enrole_app_dev/home/home_pages/overview.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'login/login_screen.dart';
import 'register_user/register_user_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:enrole_app_dev/services/user_data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:enrole_app_dev/services/globals.dart';
import 'admin_console/admin_console_scaffold.dart';
import 'admin_console/admin_console_pages/analytics_page/analytics_page.dart';
import 'user_settings/user_settings_scaffold.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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
          return MyApp();
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
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
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
        initialRoute: _auth.currentUser == null ? '/login' : '/home',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register-user': (context) => RegisterUserPage(),
          '/home': (context) => Home(),
          '/admin-console': (context) => AdminConsole(),
          '/user-settings': (context) => UserSettingsScaffold(),
        },
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: Global.analytics),
        ],
      ),
    );
  }
}

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final userProvider = StreamProvider<User?>((ref) {
  // final stream = FirebaseAuth.instance.authStateChanges();

  // final streamController = StreamController<User>();

  // streamController.addStream(stream);

  ref.onDispose(() {
    // streamController.close();
  });

  // final watchAuth = ref.watch(firebaseAuthProvider);
  
  return ref.watch(firebaseAuthProvider).userChanges();
});

final joinedOrgsProvider = StreamProvider<List<JoinedOrg>>((ref) {
  final currentUser = ref.watch(userProvider);

  final streamController = StreamController<List<JoinedOrg>>();

  currentUser.whenData((value) {
    final stream =
        UserDatabaseService().streamJoinedOrgs(currentUser.data!.value!.uid);
    streamController.addStream(stream);
  });

  ref.onDispose(() {
    // streamController.close();
  });

  return streamController.stream;
});

final currentOrgProvider = ChangeNotifierProvider<CurrentOrg>((ref) {
  final _joinedOrgs = ref.watch(joinedOrgsProvider);

  CurrentOrg returnOrg = CurrentOrg();

  print('Building currentOrgProvider');
  _joinedOrgs.whenData((value) {
    print('Joined orgs: ${value.toString()}');
    returnOrg.initOrg(value[0]);
  });

  print('Returning base CurrentOrg()');
  return returnOrg;
});

final currentPageProvider =
    ChangeNotifierProvider<CurrentPage>((ref) => CurrentPage());

final currentAdminPageProvider =
    ChangeNotifierProvider<CurrentAdminPage>((ref) => CurrentAdminPage());

final userDataProvider = StreamProvider<UserData>((ref) {
  final currentUser = ref.watch(userProvider);

  final streamController = StreamController<UserData>();

  currentUser.whenData((value) {
    String userID = '';
    if(currentUser.data != null)
    if(currentUser.data!.value != null)
    userID = currentUser.data!.value!.uid;

    final stream = UserDatabaseService().streamUser(userID);

    streamController.addStream(stream);
  });

  ref.onDispose(() {
    // streamController.close();
  });

  return streamController.stream;
});

class CurrentOrg with ChangeNotifier {
  JoinedOrg? _org;

  JoinedOrg? get org => _org;

  set org(JoinedOrg? org) {
    _org = org;
    notifyListeners();
  }

  void initOrg(JoinedOrg org) {
    if (_org == null) {
      _org = org;
    }
    notifyListeners();
  }

  String getOrgURL() {
    if (_org != null) {
      return _org!.orgImageURL!;
    } else {
      return "https://cdn4.iconfinder.com/data/icons/web-and-mobile-ui/24/UI-33-512.png";
    }
  }

  String getUserRole() {
    if (_org != null) {
      return _org!.userRole!;
    } else {
      return "member";
    }
  }

  String getOrgID() {
    if (_org != null) {
      return _org!.orgID!;
    } else {
      return "Error";
    }
  }

  String getOrgName() {
    if (_org != null) {
      return _org!.orgName!;
    } else {
      return "Error";
    }
  }
}

class CurrentPage with ChangeNotifier {
  Widget _pageWidget = Overview();
  String _pageTitle = 'Join an Org';
  String _tag = 'overview';

  Widget get pageWidget => _pageWidget;

  String get pageTitle => _pageTitle;

  String get tag => _tag;

  set pageWidget(Widget widget) {
    _pageWidget = widget;
    notifyListeners();
  }

  set pageTitle(String title) {
    _pageTitle = title;
    notifyListeners();
  }

  set tag(String tag) {
    _tag = tag;
    notifyListeners();
  }
}

class CurrentAdminPage with ChangeNotifier {
  Widget _pageWidget = AnalyticsPage();
  String _pageTitle = 'Analytics';

  Widget get pageWidget => _pageWidget;

  String get pageTitle => _pageTitle;

  set pageWidget(Widget widget) {
    _pageWidget = widget;
    notifyListeners();
  }

  set pageTitle(String title) {
    _pageTitle = title;
    notifyListeners();
  }
}

class CurrentUser with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  User? get user => _user;

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  Stream<User?> userStream() {
    return _auth.userChanges();
  }
}
