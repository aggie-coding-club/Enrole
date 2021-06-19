import 'package:enrole_app_dev/home/home_pages/overview.dart';
import 'package:enrole_app_dev/services/user_data.dart';
import 'package:flutter/material.dart';
import 'package:enrole_app_dev/home/home.dart';
import 'package:enrole_app_dev/services/user_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:enrole_app_dev/home/home_pages/search_orgs/search_orgs.dart';
import 'package:enrole_app_dev/home/home_pages/register_organization/register_organization.dart';
import 'package:enrole_app_dev/home/home_pages/search_orgs/search_by_id/search_by_id_page.dart';

class orgEndDrawer extends ConsumerWidget {
  @override
  build(BuildContext context, ScopedReader watch) {
    print('Here we are');
    final orgListAsync = watch(joinedOrgsProvider);

    return orgListAsync.when(
        loading: () => CircularProgressIndicator(),
        error: (error, _) => Text('An error occurred'),
        data: (data) {
          List<Widget> tiles = [];

          List<JoinedOrg> orgList = data;

          tiles = List.generate(orgList.length, (index) {
            return Card(
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      image: orgList[index].orgImageURL == null ? NetworkImage('https://www.computerhope.com/jargon/e/error.png') : NetworkImage(orgList[index].orgImageURL!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 50.0,
                  width: 50.0,
                ),
                title: orgList[index].orgName == null ? Text('An error occurred') : Text(orgList[index].orgName!),
                subtitle: Text(
                    "${orgList[index].userRole![0].toUpperCase()}${orgList[index].userRole!.substring(1)}"),
                onTap: () {
                  context.read(currentOrgProvider).org = orgList[index];
                  final currentPage = context.read(currentPageProvider);
                  currentPage.pageWidget = Overview();
                  currentPage.pageTitle = orgList[index].orgName!;
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
                final currentPage = context.read(currentPageProvider);
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
                final currentPage = context.read(currentPageProvider);
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
                final currentPage = context.read(currentPageProvider);
                currentPage.pageWidget = RegisterOrganizationPage();
                currentPage.pageTitle = 'Register an Organization';
                Navigator.pop(context);
              },
            ),
          ));

          return ListView(
            children: tiles,
          );
        });
  }
}
