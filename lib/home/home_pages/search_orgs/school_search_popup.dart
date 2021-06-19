import 'package:enrole_app_dev/builders/school_search.dart';
import 'package:flutter/material.dart';


/* 
this function has been deprecated
*/


// class SchoolSearchPopup extends StatefulWidget {

//   final Function? setSchool;

//   SchoolSearchPopup({this.setSchool});

//   @override
//   _SchoolSearchPopupState createState() => _SchoolSearchPopupState();
// }

// class _SchoolSearchPopupState extends State<SchoolSearchPopup> {

//   String? _searchQuery;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: (){
//           FocusScopeNode currentFocus = FocusScope.of(context);
//           if(!currentFocus.hasPrimaryFocus){
//             currentFocus.unfocus();
//           }
//         },
//         child: SafeArea(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     iconSize: 40.0,
//                     icon: Icon(Icons.clear),
//                     onPressed: (){
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//               Container(
//                 padding: EdgeInsets.all(16.0),
//                 child: TextField(
//                   onChanged: (value){
//                     setState(() {
//                       _searchQuery = value;
//                     });
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: _searchQuery != null
//                   ? FutureBuilder(
//                   future: searchSchools(query: _searchQuery),
//                   builder: (context, snap){
//                     if(snap.connectionState == ConnectionState.done){
//                       List<String> schools = snap.data;
//                       return ListView.builder(
//                         physics: BouncingScrollPhysics(),
//                         itemCount: schools.length > 20 ? 20 : schools.length,
//                         itemBuilder: (context, index){
//                           return Card(
//                             child: ListTile(
//                               title: Text(schools[index]),
//                               onTap: (){
//                                 this.widget.setSchool(schools[index]);
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           );
//                         },
//                       );
//                     } else{
//                       return Column(
//                         children: [
//                           CircularProgressIndicator(),
//                         ],
//                       );
//                     }
//                   },
//                 )
//                     : Container()
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
