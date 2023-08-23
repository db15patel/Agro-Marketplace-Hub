import 'package:agrocart/AppScreens/admin/Addthings.dart';
import 'package:agrocart/AppScreens/admin/dashboard.dart';
import 'package:agrocart/AppScreens/admin/manageThings.dart';
import 'package:agrocart/AppScreens/customer/categories.dart';
import 'package:agrocart/AppScreens/customer/homescreen.dart';
import 'package:agrocart/AppScreens/customer/profile.dart';
import 'package:agrocart/backend/api/user_api.dart';
import 'package:agrocart/backend/models/user_model.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  String currentuser;
  HomeScreen({Key key, this.currentuser}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    @override
  void initState() {
    super.initState();
    getAdminUsers();
  }
  // _HomeScreenState({Key key, this.uid});
  // HomeScreen obj = HomeScreen();
  // static String uid = widget.currentuser;
  
  UserModel user = UserModel();
  int _selectedPage = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  bool progress = false;


  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

    getAdminUsers() async {
    setState(() {
      progress = true;
    });
    await Firebase.initializeApp();

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('admins').get();

    snapshot.docs.forEach((document) {
      print(document.data()['adminId']);
      AgrocartUniversal.adminList.add(document.data()['adminId']);
    });

    setState(() {
      progress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pageOptions =
         AgrocartUniversal.adminList.contains(widget.currentuser)
            ? [
                Dashboard(),
                AddThings(),
                ManageThings(),
                // Products(),
                // Users(),
              ]
            : [
                HomeScreenCustomers(),
                Categories(),
                Profile(signout),
              ];
    // print(currentuser);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        child: progress == true
          ? Scaffold(
              body: Center(
              child: CircularProgressIndicator(),
            ))
          : Scaffold(
            body: PageStorage(
              child: _pageOptions[_selectedPage],
              bucket: bucket,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 30,
              selectedItemColor: AgrocartUniversal.contrastColor,
              unselectedItemColor: Colors.black,
              currentIndex: _selectedPage,
              onTap: (int index) {
                setState(() {
                  _selectedPage = index;
                });
              },
              items: AgrocartUniversal.adminList.contains(widget.currentuser)
                  ? [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        title: Text('Dashboard'),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_circle),
                        title: Text('Add'),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.category),
                        title: Text('Manage'),
                      ),
                      // BottomNavigationBarItem(
                      //   icon: Icon(Icons.people),
                      //   title: Text('Users'),
                      // ),
                    ]
                  : [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        title: Text('Home'),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.category),
                        title: Text('Categories'),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        title: Text('Profile'),
                      ),
                    ],
            )),
      ),
    );
    // AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('HomeScreens',
    //         style: TextStyle(
    //           color: Colors.black,
    //         )),
    //   ),
    //   body: Container(
    //       child: Column(
    //     children: [
    //       // Center(child: Text(user.id)),
    //       RaisedButton(
    //         child: Text('LogOut'),
    //         onPressed: () => signout(authNotifier),
    //       ),
    //       // RaisedButton(
    //       //   child: Text('Google Logout'),
    //       //   onPressed: () => handleSignOut(),
    //       // ),
    //     ],
    //   )),
    // );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
