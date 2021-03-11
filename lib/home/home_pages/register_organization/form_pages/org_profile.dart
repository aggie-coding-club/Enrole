import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OrgProfileFormPage extends StatefulWidget {

  final File image;
  final List<String> tags;
  final String bio;

  final Function hidePageControllers;
  final Function showPageControllers;

  final Function setImage;
  final Function setTags;
  final Function setBio;
  OrgProfileFormPage({this.setImage, this.setTags, this.setBio, this.image, this.tags, this.bio, this.hidePageControllers, this.showPageControllers});

  @override
  _OrgProfileFormPageState createState() => _OrgProfileFormPageState();
}

class _OrgProfileFormPageState extends State<OrgProfileFormPage> {

  TextEditingController tagController = TextEditingController();

  TextEditingController bioController = TextEditingController();

  final _picker = ImagePicker();

  final _storage = FirebaseStorage.instance;

  String tagText;
  String tagTextHint = '';
  List<String> tags = [];
  String bio = '';

  File _image;

  ImageProvider<dynamic> orgProfilePic = AssetImage('assets/group_default_pic.jpg');



  Future getImageFromGallery() async {
    print('test');
    var status = await Permission.photos.status;
    print('test $status');
    if(status.isDenied) {
      Permission.photos.request();
      }
    else if(status.isGranted){
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      print('posted image');
      this.widget.setImage(File(pickedFile.path));
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  @override
  void initState() {
    super.initState();
    bioController.text = this.widget.bio != null ? this.widget.bio : '';
  }

  @override
  Widget build(BuildContext context) {

    TextStyle _labelTextStyle = TextStyle(
      fontSize: 20.0,
      color: Theme.of(context).primaryColor,
      letterSpacing: 0.3,
      fontWeight: FontWeight.bold,
    );

    tags = this.widget.tags;

    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.all(12.0),
          child: Material(
            elevation: 6.0,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Profile pic',
                    style: _labelTextStyle,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 75.0,
                        backgroundImage: this.widget.image == null ? null : Image.file(this.widget.image).image,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(12.0),
                      child: RaisedButton(
                        onPressed: (){
                          getImageFromGallery();
                        },
                        child: Text('Set Profile Pic'),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bio',
                    style: _labelTextStyle,
                  ),
                ),
                Container(
                  height: 220.0,
                  margin: EdgeInsets.all(12.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: TextField(
                    controller: bioController,
                    minLines: null,
                    maxLines: null,
                    maxLength: 220,
                    expands: true,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    onTap: (){
                      this.widget.hidePageControllers();
                    },
                    onChanged: (value){
                      this.widget.setBio(value);
                    },
                    onSubmitted: (value){
                      this.widget.showPageControllers();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tags',
                    style: _labelTextStyle,
                  ),
                ),
                Container(
                  height: 340.0,
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: tagController,
                        maxLength: 20,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: (){
                          this.widget.hidePageControllers();
                        },
                        onChanged: (value){
                          setState(() {
                            tagText = value;
                          });
                        },
                        onSubmitted: (value){
                          print(value);
                          setState(() {
                            if(tags.contains(tagText)){
                              tagTextHint = 'You already added this tag';
                            } else if(tagText.length < 3){
                              tagTextHint = 'Minimum tag length is 3';
                            } else if(tags.length > 4){
                              tagTextHint = 'Maximum number of categories is 5';
                            } else if(tagText.length > 20){
                              tagTextHint = 'Maximum tag name length is 20';
                            } else{
                              tagTextHint = '';
                              tags = [...tags, tagText];
                              this.widget.setTags(tags);
                              tagController.clear();
                            }
                          });
                          this.widget.showPageControllers();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Social, Volunteering, business, etc.',
                          labelText: 'Tags',
                          fillColor: Theme.of(context).primaryColor,
                          focusColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      Container(
                        height: 16.0,
                        margin: EdgeInsets.only(bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          tagTextHint,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4.0)
                          ),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: this.widget.tags.length,
                            itemBuilder: (context, index){
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    this.widget.tags[index],
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: (){
                                      setState(() {
                                        tags.remove(tags[index]);
                                      });
                                      this.widget.setTags(tags);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
