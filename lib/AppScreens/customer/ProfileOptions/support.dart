import 'package:agrocart/universal/add_scaffold.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:agrocart/utils/dialouge.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  Future<void> _launched;
  String _phone = "7779033387";
  String _phone2 = "9978782950";
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AddScaffold(
        body: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Ink(
                height: MediaQuery.of(context).size.height * 0.33,
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: AgrocartUniversal.customBoxShadow,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                            AgrocartUniversal.supportString,
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Email: ',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: AgrocartUniversal.contrastColor)),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text('agrocartsupport@gmail.com',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        
                            child: Flexible(
                              fit: FlexFit.loose,
                              child: Column(children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: () async {
                                    final action = await Dialogs.yesAbortDialog(
                                        context,
                                        'Confirm',
                                        'Are you sure want to call this number?');
                                    if (action == DialogAction.yes) {
                                      setState(() {
                                        _launched =
                                            _makePhoneCall('tel:$_phone');
                                      });
                                    } else {
                                     
                                    }
                                  },
                                  child: Ink(
                                    height: 45,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow:
                                          AgrocartUniversal.customBoxShadow,
                                      color: AgrocartUniversal.contrastColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Call Dax Patel',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: () async {
                                    final action = await Dialogs.yesAbortDialog(
                                        context,
                                        'Confirm',
                                        'Are you sure want to to call this number?');
                                    if (action == DialogAction.yes) {
                                      setState(() {
                                        _launched =
                                            _makePhoneCall('tel:$_phone2');
                                      });
                                    } else {
                                      // setState(
                                      //     () => Navigator.of(context).pop());
                                    }
                                  },
                                  child: Ink(
                                    height: 45,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow:
                                          AgrocartUniversal.customBoxShadow,
                                      color: AgrocartUniversal.contrastColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Call Harsh Patel',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),

                            ),
                          
                        
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ))),
        title: 'Support');
  }
}
