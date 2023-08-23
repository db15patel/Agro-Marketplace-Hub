import 'package:agrocart/backend/api/product_api.dart';
import 'package:agrocart/backend/api/user_api.dart';
import 'package:agrocart/backend/notifier/auth_notofier.dart';
import 'package:agrocart/backend/notifier/product_notifier.dart';
import 'package:agrocart/universal/add_scaffold.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool dataGotForDashboard = false;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  Widget build(BuildContext context) {
    return AddScaffold(
        title: 'DashBoard',
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        print(snapshot);
                        print("tempIndex");
                        QuerySnapshot snapshott = snapshot.data;
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ActionCardLong(
                              icon: Icons.people,
                              user: snapshott.docs.length,
                              title: 'Number of Users',
                            ),
                          ),
                        );
                      }
                    }),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Categories')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.data.documents.length == 0) {
                          return Center(
                            child: Text(
                              'You don not have any category',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          );
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                            ),
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot snapshott =
                                  snapshot.data.documents[index];
                              print("${snapshott.data()['count']}");
                              return Container(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ActionCard(
                                      icon: Image.network(
                                        snapshott.data()['image'],
                                        height: 50,
                                      ),
                                      data: snapshott.data()['count'],
                                      title: snapshott.data()['categoryName'],
                                    ),
                                  ));
                            },
                            physics: NeverScrollableScrollPhysics(),
                          );
                        }
                      }
                    }),
              ],
            ))));
  }
}

class ActionCard extends StatelessWidget {
  final Function onPressed;
  final Image icon;
  final String title;
  final int data;

  const ActionCard({Key key, this.onPressed, this.icon, this.title, this.data})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Color(0xffffb3b3),
      borderRadius: BorderRadius.circular(8),
      hoverColor: AgrocartUniversal.contrastColor,
      onTap: onPressed,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.21,
        width: MediaQuery.of(context).size.height * 0.21,
        decoration: BoxDecoration(
            color: AgrocartUniversal.contrastColorLight,
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Color(0xfff8bc05))
            boxShadow: AgrocartUniversal.customBoxShadow),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, top: 15),
                  height: 70,
                  child: Tab(
                    child: icon,
                  ),
                ),
                Container(
                  height: 75,
                  padding: EdgeInsets.only(left: 10, top: 15),
                  child: Text(
                    data.toString(),
                    style: TextStyle(
                      fontSize: 42,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                right: 15,
                left: 15,
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white, fontSize: 17,
                  //fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionCardLong extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final int user;
  final String title;

  const ActionCardLong(
      {Key key, this.icon, this.onPressed, this.user, this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Color(0xffffb3b3),
      borderRadius: BorderRadius.circular(8),
      hoverColor: AgrocartUniversal.contrastColor,
      onTap: onPressed,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AgrocartUniversal.contrastColorLight,
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Color(0xfff8bc05))
            boxShadow: AgrocartUniversal.customBoxShadow),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 10, left: 15, top: 17),
                  height: 70,
                  child: Icon(
                    icon,
                    size: 50,
                    color: AgrocartUniversal.contrastColor,
                  ),
                ),
                Container(
                  height: 75,
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    user.toString(),
                    style: TextStyle(
                      fontSize: 42,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                right: 15,
                left: 15,
              ),
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
