import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Page0Controllers extends StatefulWidget {
  final PageController _pageController;

  Page0Controllers(this._pageController);
  @override
  _Page0ControllersState createState() => _Page0ControllersState();
}

class _Page0ControllersState extends State<Page0Controllers> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8.0,
      bottom: 8.0,
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10.0,),
            Icon(
              AntDesign.arrowright,
              size: 25.0,
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
        onPressed: (){
          this.widget._pageController.animateToPage(1, duration: Duration(milliseconds: 800), curve: Curves.bounceOut);
        },
      ),
    );
  }
}

class Page1Controllers extends StatefulWidget {

  final PageController _pageController;

  Page1Controllers(this._pageController);

  @override
  _Page1ControllersState createState() => _Page1ControllersState();
}

class _Page1ControllersState extends State<Page1Controllers> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8.0,
      left: 8.0,
      right: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
            child: Row(
              children: [
                Icon(
                  AntDesign.arrowleft,
                  size: 25.0,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: 10.0,),
                Text(
                  'General',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            onPressed: (){
              this.widget._pageController.animateToPage(0, duration: Duration(milliseconds: 800), curve: Curves.bounceOut);
            },
          ),
          FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Verify',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10.0,),
                Icon(
                  AntDesign.arrowright,
                  size: 25.0,
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
            onPressed: (){
              this.widget._pageController.animateToPage(2, duration: Duration(milliseconds: 800), curve: Curves.bounceOut);
            },
          ),
        ],
      ),
    );
  }
}

class Page2Controllers extends StatefulWidget {
  final PageController _pageController;

  Page2Controllers(this._pageController);
  @override
  _Page2ControllersState createState() => _Page2ControllersState();
}

class _Page2ControllersState extends State<Page2Controllers> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8.0,
      bottom: 8.0,
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              AntDesign.arrowleft,
              size: 25.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 10.0,),
            Text(
              'Profile',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onPressed: (){
          this.widget._pageController.animateToPage(1, duration: Duration(milliseconds: 800), curve: Curves.bounceOut);
        },
      ),
    );;
  }
}
