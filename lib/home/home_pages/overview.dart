import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {

  Widget myWidget ({String title, String subtitle}){
    return Card(
          child: ListTile(
            leading: Icon(Icons.announcement_outlined),
            title: Text(title),
            subtitle: Text(subtitle),
            onTap: (){
              print('Hello button clicked');
            },
          ),
        );
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        myWidget(title: "title", subtitle: "subtitle"),
        myWidget(title: "title2", subtitle: "subtitle2"),
        myWidget(title: "title3", subtitle: "subtitle3"),
        myWidget(title: "title4", subtitle: "subtitle4"),
      ],
    );
  }
}
