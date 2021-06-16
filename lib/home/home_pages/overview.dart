import 'package:flutter/material.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      if(context.read(currentPageProvider).tag != 'overview'){
          context.read(currentPageProvider).tag = 'overview';
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Overview Screen');
  }
}
