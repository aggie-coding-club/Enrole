import 'dart:convert';
import 'package:flutter/material.dart';

/* 
This file has been deprecated

*/

class School{  // Defines the class "school" to be used in _________
  final String? domain;
  final String? name;

  School({this.domain, this.name});

  factory School.fromJson(Map<String, dynamic> json){ // Allows for dot notation to return the name of the school when searched
    return School(
      domain: json['domain'],  // Parses JSON for the "name" label
      name: json['name'],
    );
  }
}

// class SchoolList {
//   final List<School>? schools;

//   SchoolList({this.schools});

//   factory SchoolList.fromJson(List<dynamic> parsedJson){
//     List<School> schools = parsedJson.map((e) => School.fromJson(e)).toList();

//     return SchoolList(
//       schools: schools,
//     );
//   }
// }


// class SearchResults extends StatefulWidget {

//   final String? query;

//   SearchResults({this.query});

//   @override
//   _SearchResultsState createState() => _SearchResultsState();
// }

// class _SearchResultsState extends State<SearchResults> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: FutureBuilder(
//           future: searchSchools(),
//           builder: (context, snapshot){
//             print('got here');
//             if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
//               List<String> schools = snapshot.data;
//               List<Widget> results = List<Widget>.generate(schools.length <= 7 ? schools.length : 7, (index) {
//                 return Text(schools[index]);
//               });
//               return Column(
//                 children: results,
//               );
//             } else {
//               return CircularProgressIndicator();
//             }
//           },
//         )
//     );
//   }
// }
