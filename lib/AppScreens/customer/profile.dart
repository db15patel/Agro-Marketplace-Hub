import 'package:agrocart/AppScreens/admin/products/dialouge.dart';
import 'package:agrocart/AppScreens/customer/ProfileOptions/aboutUs.dart';
import 'package:agrocart/AppScreens/customer/ProfileOptions/faq.dart';
import 'package:agrocart/AppScreens/customer/ProfileOptions/support.dart';
import 'package:agrocart/AppScreens/customer/purchaseList.dart';
import 'package:agrocart/backend/api/user_api.dart';
import 'package:agrocart/backend/models/user_model.dart';
import 'package:agrocart/backend/notifier/auth_notofier.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

UserModel userModel = UserModel();
bool currentData = false;

class Profile extends StatefulWidget {
  final Function(AuthNotifier authNotifier) _signOut;

  const Profile(this._signOut);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: TextStyle(
              color: Colors.black,
            )),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(authNotifier.userId)
              .get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            } else {
              Map<String, dynamic> data = snapshot.data.data();

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    child: Column(
                  children: [
                    ProfileActionCard(
                        name: data['displayName'],
                        number: data['phoneNumber'],
                        address: data['address'],
                        image: Image.asset(
                          'assets/avataar.png',
                        ),
                        func: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PurchaseList(authNotifier.userId)));
                        }),
                    // Center(child: Text(user.id)),
                    SizedBox(
                      height: 15,
                    ),

                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ProductsCom(
                        //               depname: fertilizer,
                        //             )));
                      },
                      child: Align(
                        child: Ink(
                          width: MediaQuery.of(context).size.width,
                          //height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: AgrocartUniversal.customBoxShadow,
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Settings(
                                  name: 'Support',
                                  iconData: Icons.people,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => Support()));
                                  },
                                ),
                                SizedBox(height: 8),
                                Settings(
                                  name: 'F.A.Q',
                                  iconData: Icons.chat_bubble_outline,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                FaqActivity()));
                                  },
                                ),
                                SizedBox(height: 8),
                                Settings(
                                  name: 'Invite your Friends',
                                  iconData: Icons.person_add,
                                  onPressed: () => Share.share(
                                      "Download the new GoodWill App and share with your friends- " +
                                          "https://play.google.com/store/apps/details?id=" +
                                          'com.gce.clubgamma' +
                                          "\n\n"),
                                ),
                                SizedBox(height: 8),
                                // Settings(
                                //   name: 'About Us',
                                //   iconData: Icons.info_outline,
                                // ),
                                // SizedBox(height: 8),
                                Settings(
                                  name: 'About Us',
                                  iconData: Icons.info_outline,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                AboutUs()));
                                  },
                                ),
                                SizedBox(height: 8),
                                Settings(
                                    name: 'Logout',
                                    iconData: Icons.exit_to_app,
                                    onPressed: () async {
                                      final action = await Dialogs.yesAbortDialog(
                                          context,
                                          'Confirm',
                                          'Are you sure want to Logout from the Application?');
                                      if (action == DialogAction.yes) {
                                        widget._signOut(authNotifier);
                                      } else {}
                                    }
                                    //() => _signOut(authNotifier),
                                    ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              );
            }
          }),
    );
  }
}

class ProfileActionCard extends StatelessWidget {
  final String name;
  final String address;
  final String number;
  final Image image;
  final Function func;

  const ProfileActionCard(
      {Key key, this.name, this.address, this.number, this.image, this.func})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('In Current profile card');
    print(name);
    print(address);
    print(number);
    return InkWell(
      //splashColor: Color(0xffffb3b3),
      borderRadius: BorderRadius.circular(8),
      hoverColor: AgrocartUniversal.contrastColor,
      //onTap: func,
      child: Ink(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Color(0xfff8bc05))
            boxShadow: AgrocartUniversal.customBoxShadow),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Tab(
                        child: image,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          // fit: FlexFit.loose,
                          child: Text(
                            name,
                            style: TextStyle(color: Colors.black, fontSize: 28),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Icon(
                                Icons.home,
                                size: 20,
                                color: AgrocartUniversal.contrastColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                address,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 5),
                        Row(
                          children: [
                            Container(
                              child: Icon(
                                Icons.phone,
                                size: 20,
                                color: AgrocartUniversal.contrastColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              // fit: FlexFit.loose,
                              child: Text(
                                number.toString(),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: func,
                child: Ink(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: AgrocartUniversal.customBoxShadow,
                      color: AgrocartUniversal.contrastColor,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Purchase History',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  final String name;
  final IconData iconData;
  final Function onPressed;

  const Settings({Key key, this.name, this.iconData, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Icon(
              iconData,
              size: 23,
              color: AgrocartUniversal.contrastColor,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
