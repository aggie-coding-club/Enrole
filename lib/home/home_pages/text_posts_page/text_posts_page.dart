import 'package:flutter/material.dart';

class TextPostPage extends StatefulWidget {
  @override
  _TextPostPageState createState() => _TextPostPageState();
}

class _TextPostPageState extends State<TextPostPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Remember to turn in applications!'),
              subtitle: Text('Applications are due this thursday. Please email me or Sarah if you have any questions!'),
              leading: CircleAvatar(),
            ),
          ),
        ),
      ],
    );
  }
}




class TextPost{
  String body;
  String title;
  String author;
  String date;
  String attachments;

  TextPost({this.body, this.title, this.date, this.attachments, this.author});
}
