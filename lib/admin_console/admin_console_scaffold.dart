import 'package:flutter/material.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:enrole_app_dev/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_console_pages/analytics_page/analytics_page.dart';
import 'admin_console_pages/manage_members_page/manage_members_page.dart';
import 'admin_console_pages/org_settings_page/org_settings_page.dart';
import 'admin_console_pages/org_notifications/org_notifications_page.dart';



class AdminConsole extends StatefulWidget {
  @override
  _AdminConsoleState createState() => _AdminConsoleState();
}

class _AdminConsoleState extends State<AdminConsole> {

  int _bottomDrawerIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.read(currentOrgProvider).getOrgID()),
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
         bottomNavigationBar: BottomNavigationBar(
            currentIndex: _bottomDrawerIndex,
            showUnselectedLabels: false,
            backgroundColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            onTap: (index){
              setState(() {
                _bottomDrawerIndex = index;
              });
              switch (index){
                case 0:
                  context.read(currentAdminPageProvider).pageWidget = ManageMembersPage();
                break;
                case 1:
                  context.read(currentAdminPageProvider).pageWidget = AnalyticsPage();
                break;
                case 2:
                  context.read(currentAdminPageProvider).pageWidget = OrgNotificationsPage();
                break;
                case 3:
                  context.read(currentAdminPageProvider).pageWidget = OrgSettingsPage();
                break;
              }
            },
            items: [
              BottomNavigationBarItem(
                label: "Members",
                icon: Icon(Icons.group),
              ),
              BottomNavigationBarItem(
                label: "Analytics",
                icon: Icon(Icons.bar_chart_rounded),
              ),
              BottomNavigationBarItem(
                label: "Notifications",
                icon: Icon(Icons.notifications),
              ),
              BottomNavigationBarItem(
                label: "Settings",
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        body: context.read(currentAdminPageProvider).pageWidget,
      );
  }
}