import 'package:agrocart/AppScreens/admin/add/addOffer.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OfferList extends StatefulWidget {
  @override
  _OfferListState createState() => _OfferListState();
}

class _OfferListState extends State<OfferList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Offer List'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('Offers').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data.documents.length == 0) {
                      return Center(
                        child: Text(
                          'You have not added any offers',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      );
                    } else {
                      print("in else");
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot snapshott =
                              snapshot.data.documents[index];

                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 11, right: 11, bottom: 7),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddOffer(
                                              snapshot: snapshott,
                                              isUpdating: true,
                                            )));
                              },
                              child: Ink(
                                //width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow:
                                      AgrocartUniversal.customBoxShadow,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  // width: MediaQuery.of(context).size.width *
                                  //     0.8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshott.data()['name'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        snapshott.data()['about'],
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        physics: NeverScrollableScrollPhysics(),
                      );
                    }
                  }
                }),
          ),
        ));
  }
}
