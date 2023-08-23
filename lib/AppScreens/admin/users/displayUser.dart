import 'dart:core' as prefix1;
import 'dart:core';
import 'package:agrocart/AppScreens/admin/Addthings.dart';
import 'package:agrocart/AppScreens/admin/add/signup.dart';
import 'package:agrocart/AppScreens/admin/products/dialouge.dart';
import 'package:agrocart/AppScreens/admin/users/purchaseHistory.dart';
import 'package:agrocart/AppScreens/customer/purchaseList.dart';
import 'package:agrocart/backend/notifier/auth_notofier.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

Widget divider() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
    child: Container(
      width: 0.8,
    ),
  );
}

class UserEdit extends StatefulWidget {
  @override
  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  Icon searchIcon = new Icon(Icons.search);
  Icon bookIcon = new Icon(Icons.bookmark);
  DocumentSnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    AuthNotifier authnotifierr = Provider.of<AuthNotifier>(context);
    double width = MediaQuery.of(context).size.width;

    // Future<bool> _disposee() async {
    //   AuthNotifier authNotifier =
    //       Provider.of<AuthNotifier>(context, listen: false);
    //   authNotifier.currentUser = null;
    //   Navigator.of(context).pop(true);
    //   return true;
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit User',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: authnotifierr.currentUser == null
          ? Container()
          : Stack(
              children: [
                SingleChildScrollView(
                    //  slivers: <Widget>[

                    child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Ink(
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: AgrocartUniversal.customBoxShadow,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    child: ListTile(
                                      title: Text('Name',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: AgrocartUniversal
                                                  .contrastColor)),
                                      subtitle: Text(
                                          authnotifierr
                                                  .currentUser.displayName ??
                                              '' ??
                                              '',
                                          style: TextStyle()),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    child: ListTile(
                                      title: Text('Phone number',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: AgrocartUniversal
                                                  .contrastColor)),
                                      subtitle: Text(
                                          authnotifierr
                                                  .currentUser.phoneNumber ??
                                              '' ??
                                              '',
                                          style: TextStyle()),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    child: ListTile(
                                      title: Text('Address',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: AgrocartUniversal
                                                  .contrastColor)),
                                      subtitle: Text(
                                          authnotifierr.currentUser.address ??
                                              '' ??
                                              '',
                                          style: TextStyle()),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    child: ListTile(
                                      title: Text('Password',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: AgrocartUniversal
                                                  .contrastColor)),
                                      subtitle: Text(
                                          authnotifierr.currentUser.password ??
                                              '' ??
                                              '',
                                          style: TextStyle()),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Wrap(
                            spacing: 20,
                            runSpacing: 20.0,
                            children: [
                              ActionCard(
                                  icon: Icons.history,
                                  title: 'Add purchase history',
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                PurchaseHistory(
                                                    authnotifierr
                                                        .currentUser.uid,
                                                    snapshot,
                                                    false)));
                                  }),

                                   SizedBox(
                            height: 13,
                          ),
                          ButtonClass(
                            name: 'See Purchase History',
                            func: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => PurchaseList(
                                          authnotifierr.currentUser.uid)));
                            },
                          ),
                          SizedBox(height: 15),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )

                    //  ],
                    ),
              ],
            ),
      bottomNavigationBar: Material(
        elevation: 15,
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          height: 55.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: width * 0.5,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUp(
                                      isUpdating: true,
                                    )));
                      },
                      child: Text(
                        'EDIT',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    )),
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: width * 0.5,
                  color: Colors.redAccent,
                  child: InkWell(
                    onTap: () async {
                      final action = await Dialogs.yesAbortDialog(context,
                          'Confirm', 'Are you sure want to delete this User?');
                      if (action == DialogAction.yes) {
                        setState(() {
                          // deleteFood(authnotifierr.currentUser, _onFoodDeleted);
                          toast();
                        });
                      } else {
                        //setState(() => Navigator.of(context).pop());
                      }
                    },
                    child: Text(
                      'DELETE',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  void toast() {
    Fluttertoast.showToast(
        msg: "Book Deleted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
