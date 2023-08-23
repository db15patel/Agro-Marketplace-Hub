import 'package:agrocart/AppScreens/admin/products/dialouge.dart';
import 'package:agrocart/AppScreens/admin/products/productsList.dart';
import 'package:agrocart/backend/notifier/auth_notofier.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

QuerySnapshot object;
// String pesticides = 'pesticides';
// String fertilizer = 'fertilizers';
// String seeds = 'seeds';
// String hardware = 'hardware';

class Category extends StatefulWidget {
  const Category({Key key, this.ontap}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
  final VoidCallback ontap;
}

class _CategoryState extends State<Category> {
  Icon searchIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Products'),
      ),
      body: SingleChildScrollView(
              child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('Categories').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.data.documents.length == 0) {
                  print('in NULL sec');
                  return Center(
                    child: Text(
                      'You do not have any Category, add one!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  );
                } else {
                  print("tempIndex");
                  return
                      //print(categories[tempIndex]);
                      ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot snapshott = snapshot.data.documents[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 7),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsCom(
                                  depname: snapshott.data()['categoryName'],
                                ),
                              ),
                            );
                          },
                          onLongPress: AgrocartUniversal.adminList.contains(authNotifier.userId) ? ()async {
                            final action = await Dialogs.yesAbortDialog(
                                context,
                                'Confirm',
                                'Are you sure want to delete this category?');
                            if (action == DialogAction.yes) {

                               if (snapshott.data()['image'] != null) {
                              StorageReference storageReference =
                                  await FirebaseStorage.instance
                                      .getReferenceFromUrl(snapshott.data()['image']);

                              print(storageReference.path);

                              await storageReference
                                  .delete()
                                  .then((value) => print('image deleted'));

                              print('image deleted');
                            }
                              await FirebaseFirestore.instance
                                  .collection('Categories')
                                  .doc(snapshott.data()['categoryName'])
                                  .delete();
                            } else {}
                          } : (){},
                          child: Ink(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: AgrocartUniversal.customBoxShadow,
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Image.network(
                                    snapshott.data()['image'],
                                    height: 80,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 7),
                                  child: Text(
                                    snapshott.data()['categoryName'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                )
                              ],
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
    );
  }
}
