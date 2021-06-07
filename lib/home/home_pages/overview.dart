import 'package:flutter/material.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:provider/provider.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      if(Provider.of<CurrentPage>(context, listen: false).tag != 'overview'){
          Provider.of<CurrentPage>(context, listen: false).tag = 'overview';
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Overview Screen');
  }
}
