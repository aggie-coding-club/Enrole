import 'package:enrole_app_dev/keys.dart';
import 'package:enrole_app_dev/builders/school_search.dart';
import 'package:enrole_app_dev/home/home_pages/search_orgs/school_search_popup.dart';
import 'package:enrole_app_dev/main.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'org_public_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enrole_app_dev/services/user_data.dart';


class SearchOrgs extends StatefulWidget {

  final Function? callback;

  SearchOrgs({this.callback});

  @override
  _SearchOrgsState createState() => _SearchOrgsState();
}

class _SearchOrgsState extends State<SearchOrgs> {

  Algolia _algolia = Algolia.init(applicationId: algoliaAppID, apiKey: algoliaAPIKey).instance;

  TextEditingController _orgSearchController = TextEditingController();

  ScrollController _scrollController = ScrollController();


  Future<List<String>?>? schoolResults;

  String orgSearch = '';

  Future<List<Widget>?>? orgTiles;

  String searchQuery = '';

  bool typing = false;
  
  Future<List<Widget>> searchResults({String? search, BuildContext? context}) async {
    List<Widget> tiles;
    String? school = context!.read(userDataProvider).data!.value.school;
    if(search != null)
    try{
      AlgoliaQuerySnapshot querySnap = await _algolia.index('orgs').query(search).facetFilter('school:$school').getObjects();
      List<AlgoliaObjectSnapshot> results = querySnap.hits;

      tiles = List.generate(results.length, (orgIndex) {
        ImageProvider image = NetworkImage(results[orgIndex].data['profileImageURL']);
        Widget profileImage = Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover,
            ),
          ),
        );
        List<dynamic> tags = results[orgIndex].data['tags'];
        List<Widget> tagTiles = List.generate(tags.length, (tagIndex){
          return Card(
            child: Container(
              padding: EdgeInsets.all(6.0),
              child: Text(tags[tagIndex]),
            ),
          );
        });
        Widget orgTypeTile (String orgType){
          String tileString;
          Color cardColor;
          Color textColor;
          switch(orgType){
            case 'public':{
              tileString = 'Public';
              cardColor = Colors.lightGreen[200]!;
              textColor = Colors.green[800]!;
            }break;
            case 'private':{
              tileString = 'Private';
              cardColor = Colors.lightBlue[200]!;
              textColor = Colors.blue[800]!;
            } break;
            case 'application':{
              tileString = 'Application';
              cardColor = Colors.yellow[100]!;
              textColor = Colors.yellow[700]!;
            } break;
            default: {
              tileString = 'Error';
              cardColor = Colors.grey;
              textColor = Colors.black;
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: cardColor,
                child: Container(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    tileString,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return OrgPublicProfile(orgData: results[orgIndex], image: image, context: context,);
            }));
          },
          child: Card(
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6.0,),
                ListTile(
                  leading: profileImage,
                  title: Container(
                    padding: EdgeInsets.all(6.0),
                    child: Text(
                      results[orgIndex].data['orgName'],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  trailing: orgTypeTile(results[orgIndex].data['orgType']),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Wrap(
                    children: tagTiles,
                  ),
                ),
              ],
            ),
          ),
        );
      });
      return tiles;
    }catch(e){print(e);}
    return [Text('Something went wrong')];
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14.0),
            height: 80.0,
            child: TextField(
              controller: _orgSearchController,
              onChanged: (value) async {
                if(value.length > 2) {
                  setState(() {
                    searchQuery = value;
                    print('Hmm');
                    orgTiles = searchResults(search: value, context: context);
                  });
                }
              },
            ),
          ),
          Expanded(
            child: searchQuery.length > 2
                ? FutureBuilder(
                  future: searchResults(search: searchQuery, context: context),
                  builder: (context, snap){
                    if(snap.connectionState == ConnectionState.done && snap.data != null){
                      print('Algolia called');
                      List<Widget> tiles = snap.data as List<Widget>;
                      return NotificationListener(
                        onNotification: (t){
                          if(t is ScrollNotification){
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if(!currentFocus.hasPrimaryFocus){
                              currentFocus.unfocus();
                            }
                          }
                          return true;
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          itemCount: tiles.length,
                          itemBuilder: (context, index){
                            return tiles[index];
                          },
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          CircularProgressIndicator(),
                        ],
                      );
                    }
                  },
                )
                : Container(),
          ),
        ],
      ),
    );
  }
}
