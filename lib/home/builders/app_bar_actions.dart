import 'package:enrole_app_dev/services/user_data.dart';
import 'package:flutter/material.dart';
import 'package:enrole_app_dev/home/home.dart';
import 'package:enrole_app_dev/services/user_data.dart';
import 'package:provider/provider.dart';

List<PopupMenuEntry<int>> orgListMenuItems (BuildContext context){
  List<PopupMenuEntry<int>> orgDropdown = [];

  List<JoinedOrg> orgList = context.read<List<JoinedOrg>>();

  if(orgList != null){
    int index = 1;
  orgList.forEach((element) {
    orgDropdown.add(
      PopupMenuItem(
        value: index,
        child: Text(element.orgName),
      )
    );
  });
  }

  orgDropdown.add(
    PopupMenuItem(
      value: 998,
      child: Row(
        children: [
          Text("Find organizations"),
          Expanded(child: Container(),),
          Icon(Icons.search),
        ],
      ),
    )
  );
  orgDropdown.add(
    PopupMenuItem(
      value: 999,
      child: Row(
        children: [
          Text("Register an organization"),
          Expanded(child: Container(),),
          Icon(Icons.group_outlined),
        ],
      ),
    )
  );

  return orgDropdown;
}