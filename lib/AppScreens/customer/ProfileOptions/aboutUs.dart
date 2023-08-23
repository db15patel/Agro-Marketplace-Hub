// import 'package:agrocart/universal/add_scaffold.dart';
// import 'package:agrocart/utils/agrocart.dart';
// import 'package:flutter/material.dart';

// class AboutThisApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AddScaffold(
//         body: Container(
//             child: Column(
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             Ink(
//               height: MediaQuery.of(context).size.height * 0.2049,
//               width: MediaQuery.of(context).size.width * 0.88,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow:  [
//                         BoxShadow(
//                             color: Colors.black.withOpacity(0.075),
//                             blurRadius: 7,
//                             //spreadRadius: 1,
//                             offset: Offset(
//                               7,
//                               7,
//                             )),
//                         BoxShadow(
//                             color: Colors.black.withOpacity(0.015),
//                             blurRadius: 7,
//                             //spreadRadius: -1,
//                             offset: Offset(
//                               -7,
//                               -7,
//                             )),
//                       ]
                    
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8.0),
//                 child: Image.asset(
//                   AgrocartUniversal.banner,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             //...devFestTexts(context),
//             Container(
//               padding: EdgeInsets.all(10),
//               child: Text(
//                 // tempData.title,
//                 AgrocartUniversal.whatIsGoodWill,
//                 style: Theme.of(context).textTheme.headline,
//                 textAlign: TextAlign.center,
//               ),
//             ),

//             SizedBox(
//               height: 10,
//             ),

//             Container(
//               padding: EdgeInsets.only(left: 20, right: 20),
//               child: Text(AgrocartUniversal.aboutusText,
//                   textAlign: TextAlign.justify,
//                   style: TextStyle(fontSize: 14, color: Colors.grey)),
//             ),
//             SizedBox(
//               height: 20,
//             ),

//            // socialActions(context),

//             SizedBox(height: 5),

//             Text(
//               AgrocartUniversal.app_version,
//               style: Theme.of(context).textTheme.caption.copyWith(fontSize: 10),
//             ),
//             SizedBox(
//               height: 40,
//             ),

//           ],
//         )),
//         title: 'About us');
//   }
// }










import 'package:agrocart/utils/agrocart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AboutUs extends StatelessWidget {
static final DateTime now = DateTime. now();
static final DateFormat formatter = DateFormat('yyyy');
final String formatted = formatter. format(now);

@override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('About us'),
      ),

          body: Container(
          child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Ink(
            height: MediaQuery.of(context).size.height * 0.22,
            width: MediaQuery.of(context).size.width * 0.88,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: AgrocartUniversal.customBoxShadow),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                AgrocartUniversal.banner,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Address",
              style: Theme.of(context).textTheme.headline,
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            height: 2,
          ),

          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(AgrocartUniversal.address,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: Colors.grey)),
          ),
          SizedBox(
            height: 20,
          ),

          Text(
            '©$formatted AD GROUP',
            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13),
          ),
          SizedBox(
            height: 5,
          ),
            Text(
              AgrocartUniversal.app_version,
              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 10),
            ),
        ],
      )),
    );
  }
}
