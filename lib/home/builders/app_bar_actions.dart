import 'package:enrole_app_dev/home/home_pages/overview.dart';
import 'package:enrole_app_dev/services/user_data.dart';
import 'package:flutter/material.dart';
import 'package:enrole_app_dev/home/home.dart';
import 'package:enrole_app_dev/services/user_data.dart';
import 'package:provider/provider.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:enrole_app_dev/home/home_pages/search_orgs/search_orgs.dart';
import 'package:enrole_app_dev/home/home_pages/register_organization/register_organization.dart';
import 'package:enrole_app_dev/home/home_pages/search_orgs/search_by_id/search_by_id_page.dart';

List<Widget> orgPanelTiles(BuildContext context) {
  List<JoinedOrg> orgList = context.read<List<JoinedOrg>>();

  List<Widget> tiles = [];

  tiles = List.generate(orgList.length, (index) {
    return Card(
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(
              image: NetworkImage(orgList[index].orgImageURL),
              fit: BoxFit.cover,
            ),
          ),
          height: 50.0,
          width: 50.0,
        ),
        title: Text(orgList[index].orgName),
        subtitle: Text(
            "${orgList[index].userRole[0].toUpperCase()}${orgList[index].userRole.substring(1)}"),
        onTap: () {
          Provider.of<CurrentOrg>(context, listen: false).org = orgList[index];
          var currentPage = Provider.of<CurrentPage>(context, listen: false);
          currentPage.pageWidget = Overview();
          currentPage.pageTitle = orgList[index].orgName;
          Navigator.pop(context);
        },
      ),
    );
  });

  if (tiles.isEmpty) {
    tiles.add(Card(
      child: Text("You are not in any organizations"),
    ));
  }

  tiles.insert(
    0,
    Divider(
      thickness: 2.0,
      color: Colors.black,
    ),
  );
  tiles.insert(0, Text('Your Organizations'));

  tiles.add(Text('Join an Organization'));
  tiles.add(
    Divider(
      thickness: 2.0,
      color: Colors.black,
    ),
  );

  tiles.add(Card(
    child: ListTile(
      title: Text("Search by Name & Tags"),
      leading: Icon(Icons.search),
      onTap: () {
        var currentPage = Provider.of<CurrentPage>(context, listen: false);
        currentPage.pageWidget = SearchOrgs();
        currentPage.pageTitle = 'Search Organizations';
        Navigator.pop(context);
      },
    ),
  ));

  tiles.add(Card(
    child: ListTile(
      title: Text("Search by ID"),
      leading: Icon(Icons.fingerprint),
      onTap: () {
        var currentPage = Provider.of<CurrentPage>(context, listen: false);
        currentPage.pageWidget = SearchByIDPage();
        Navigator.pop(context);
      },
    ),
  ));

  tiles.add(Card(
    child: ListTile(
      title: Text("Search by QR Code"),
      leading: Icon(Icons.qr_code),
      onTap: () {},
    ),
  ));

  tiles.add(Text('Start an Organization'));
  tiles.add(
    Divider(
      thickness: 2.0,
      color: Colors.black,
    ),
  );

  tiles.add(Card(
    child: ListTile(
      title: Text("Register an Organization"),
      leading: Icon(Icons.group_outlined),
      onTap: () {
        var currentPage = Provider.of<CurrentPage>(context, listen: false);
        currentPage.pageWidget = RegisterOrganizationPage();
        currentPage.pageTitle = 'Register an Organization';
        Navigator.pop(context);
      },
    ),
  ));

  return tiles;
}

List<PopupMenuEntry<int>> orgListMenuItems(BuildContext context) {
  List<PopupMenuEntry<int>> orgDropdown = [];

  List<JoinedOrg> orgList = context.read<List<JoinedOrg>>();

  if (orgList != null) {
    int index = 0;
    orgList.forEach((element) {
      orgDropdown.add(PopupMenuItem(
        value: index,
        child: Text(element.orgName),
      ));
      index++;
    });
  }

  orgDropdown.add(PopupMenuItem(
    value: 998,
    child: Row(
      children: [
        Text("Find organizations"),
        Expanded(
          child: Container(),
        ),
        Icon(Icons.search),
      ],
    ),
  ));
  orgDropdown.add(PopupMenuItem(
    value: 999,
    child: Row(
      children: [
        Text("Register an organization"),
        Expanded(
          child: Container(),
        ),
        Icon(Icons.group_outlined),
      ],
    ),
  ));

  return orgDropdown;
}
