import 'package:agrocart/AppScreens/admin/users/displayUser.dart';
import 'package:agrocart/backend/api/user_api.dart';
import 'package:agrocart/backend/notifier/auth_notofier.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

TextEditingController searchControllerForUserlist = TextEditingController();
Future resultsLoaded;
QuerySnapshot snapshotForUser;
bool userGot = false;

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Widget appBarTitle;

  Icon searchIcon = new Icon(Icons.search);
  void initState() {
    // appBarTitle = Text('Users');
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    appBarTitle = Text('Customers');
    getUserStreamSnapshots(authNotifier);
    searchControllerForUserlist.addListener(_onSearchChangedForUser);
    super.initState();
  }

  _onSearchChangedForUser() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    searchResultsListForUser(authNotifier);
  }

  @override
  void dispose() {
    searchControllerForUserlist.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: appBarTitle,
        actions: [
          IconButton(
              icon: searchIcon,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (this.searchIcon.icon == Icons.search) {
                    this.searchIcon = new Icon(Icons.close);
                    this.appBarTitle = Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(right: 10),
                      child: new TextFormField(
                        autofocus: true,
                        cursorColor: Colors.black,
                        controller: searchControllerForUserlist,
                        style: new TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        decoration: new InputDecoration(
                            // prefixIcon:
                            //     new Icon(Icons.search, color: Colors.black),
                            hintText: "Search...",
                            hintStyle: new TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            )),
                      ),
                    );
                  } else {
                    this.searchIcon = new Icon(Icons.search);
                    this.appBarTitle = new Text("Customers");
                  }
                });
                //showSearch(context: context, delegate: DataSearch());
                //initiateSearch(value);
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => Search()));
              }),
        ],
      ),
      body: userGot == false
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: authNotifier.userListt.length == 0
                    ? Center(child: Text('No Data'))
                    : ListView.builder(
                        itemCount: authNotifier.userListt.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(authNotifier.userListt.length);
                          print(authNotifier.userListt[index].displayName);
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                authNotifier.currentUser =
                                    authNotifier.userListt[index];
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return UserEdit();
                                }));
                              },
                              child: Ink(
                                height: 80,
                                width: (MediaQuery.of(context).size.width / 2),
                                decoration: BoxDecoration(
                                  boxShadow: AgrocartUniversal.customBoxShadow,
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(top: 15),
                                        child: Text(
                                          authNotifier
                                              .userListt[index].displayName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.0,
                                          ),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 3,
                                      // ),
                                      Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          authNotifier
                                              .userListt[index].phoneNumber,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                AgrocartUniversal.contrastColor,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        physics: ClampingScrollPhysics(),
                      ),
              ),
            ),
    );
  }
}
