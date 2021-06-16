import 'package:enrole_app_dev/services/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:enrole_app_dev/builders/school_search.dart';
import 'form_pages/general_info.dart';
import 'form_pages/org_profile.dart';
import 'form_pages/page_controllers.dart';
import 'form_pages/payment_page.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'form_pages/verify_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enrole_app_dev/main.dart';

class organizationInfo {
  final String orgName;
  final String orgBio;
  final List<String> orgTags;
  final String orgImage;
  final String orgType;
  final String school;

  organizationInfo({this.orgName, this.orgBio, this.orgTags, this.orgImage, this.orgType, this.school});

}

class RegisterOrganizationPage extends StatefulWidget {
  final Function callback;

  RegisterOrganizationPage({this.callback});

  @override
  _RegisterOrganizationPageState createState() => _RegisterOrganizationPageState();
}

class _RegisterOrganizationPageState extends State<RegisterOrganizationPage> {

  PageController _pageController = PageController();


  String orgName;
  String orgType;
  String school;
  File imageFile;
  String bio;
  List<String> tags = [];

  String controllerText2;

  Function setName (String value){
    setState(() {
      orgName = value;
    });
  }

  Function setType (String type){
    setState(() {
      orgType = type;
    });
  }

  Function setImage (File image){
    setState(() {
      imageFile = image;
    });
  }

  Function setBio (String input){
    setState(() {
      bio = input;
    });
  }

  Function setTags (List<String> values){
    setState(() {
      tags = values;
    });
  }

  void pageIconController(int page){
    switch(page){
      case 0:{
        setState(() {
          icon1BackgroundColor = Theme.of(context).primaryColor;
          icon2BackgroundColor = Colors.transparent;
          icon3BackgroundColor = Colors.transparent;
          icon1Color = Colors.white;
          icon2Color = Colors.black;
          icon3Color = Colors.black;
        });
      } break;
      case 1: {
        icon1BackgroundColor = Colors.transparent;
        icon2BackgroundColor = Theme.of(context).primaryColor;
        icon3BackgroundColor = Colors.transparent;
        icon1Color = Colors.black;
        icon2Color = Colors.white;
        icon3Color = Colors.black;
      } break;
      case 2:{
        icon1BackgroundColor = Colors.transparent;
        icon2BackgroundColor = Colors.transparent;
        icon3BackgroundColor = Theme.of(context).primaryColor;
        icon1Color = Colors.black;
        icon2Color = Colors.black;
        icon3Color = Colors.white;
      }
    }
  }

  void hidePageControllers(){
    setState(() {
      currentPageControllers = Container();
    });
  }
  void showPageControllers(){
    int pageNum = _pageController.page.toInt();
    switch(pageNum){
      case 0:{
        setState(() {
          currentPageControllers = Page0Controllers(_pageController);
        });
      } break;
      case 1:{
        setState(() {
          currentPageControllers = Page1Controllers(_pageController);
        });
      } break;
      case 2:{
        setState(() {
          currentPageControllers = Page2Controllers(_pageController);
        });
      }
    }
  }

  Widget currentPage;

  Widget currentPageControllers;

  Color icon1BackgroundColor;
  Color icon2BackgroundColor;
  Color icon3BackgroundColor;

  Color icon1Color;
  Color icon2Color;
  Color icon3Color;

  @override
  void initState() {
    super.initState();
    currentPage = GeneralInfoFormPage();
    controllerText2 = 'Profile';
    currentPageControllers = Page0Controllers(_pageController);
    icon1BackgroundColor = Colors.blue[700];
    icon2BackgroundColor = Colors.transparent;
    icon3BackgroundColor = Colors.transparent;
    icon1Color = Colors.white;
    icon2Color = Colors.black;
    icon3Color = Colors.black;
    school = context.read(userDataProvider).data.value.school;
    Future.delayed(Duration.zero, () async {
      if(context.read(currentPageProvider).tag != 'registerOrg'){
          context.read(currentPageProvider).tag = 'registerOrg';
        }
    });
  }

  void dispose(){
    super.dispose();
    _pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
            Future.delayed(Duration(milliseconds: 100), showPageControllers);
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: icon1BackgroundColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        height: 40.0,
                        width: 40.0,
                        child: Icon(Icons.info_outline, color: icon1Color,),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: icon2BackgroundColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        height: 40.0,
                        width: 40.0,
                        child: Icon(Icons.art_track, color: icon2Color,),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: icon3BackgroundColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        height: 40.0,
                        width: 40.0,
                        child: Icon(Icons.check, color: icon3Color,),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    onPageChanged: (pageNum) async {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if(!currentFocus.hasPrimaryFocus){
                        currentFocus.unfocus();
                        await Future.delayed(Duration(milliseconds: 100), showPageControllers);
                      }
                      switch(pageNum){
                        case 0: {
                          setState(() {
                            currentPageControllers = Page0Controllers(_pageController);
                            pageIconController(0);
                          });
                        } break;
                        case 1: {
                          setState(() {
                            currentPageControllers = Page1Controllers(_pageController);
                            pageIconController(1);
                          });
                        } break;
                        case 2: {
                          setState(() {
                            currentPageControllers = Page2Controllers(_pageController);
                            pageIconController(2);
                          });
                        }
                      }
                    },
                    controller: _pageController,
                    physics: BouncingScrollPhysics(),
                    children: [
                      GeneralInfoFormPage(showPageControllers: showPageControllers, hidePageControllers: hidePageControllers, setName: setName, setType: setType, orgName: orgName, orgType: orgType, school: school,),
                      OrgProfileFormPage(setImage: setImage, setBio: setBio, setTags: setTags, image: imageFile, bio: bio, tags: tags, hidePageControllers: hidePageControllers, showPageControllers: showPageControllers),
                      VerifyPage(homeCallback: this.widget.callback, orgName: orgName, orgType: orgType, school: school, imageFile: imageFile, bio: bio, tags: tags,),
                    ],
                  ),
                ),
              ],
            ),
            currentPageControllers,
          ],
        ),
      );
  }
}




