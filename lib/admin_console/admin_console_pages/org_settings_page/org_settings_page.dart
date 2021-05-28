import 'package:enrole_app_dev/admin_console/admin_console_pages/manage_members_page/manage_members_page.dart';
import 'package:flutter/material.dart';
import 'manage_pages/manage_org_pages_scaffold.dart';

class OrgSettingsPage extends StatefulWidget {
  @override
  _OrgSettingsPageState createState() => _OrgSettingsPageState();
}

class _OrgSettingsPageState extends State<OrgSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ListTile(
            title: Text('Org page settings'),
            leading: Icon(Icons.pages),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ManageOrgPages()));
            },
          ),
        ),
      ],
    );
  }
}