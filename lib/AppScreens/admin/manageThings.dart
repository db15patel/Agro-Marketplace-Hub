import 'package:agrocart/AppScreens/admin/Addthings.dart';
import 'package:agrocart/AppScreens/admin/offers/offerList.dart';
import 'package:agrocart/AppScreens/admin/products/categories.dart';
import 'package:agrocart/AppScreens/admin/users/userList.dart';
import 'package:agrocart/universal/add_scaffold.dart';
import 'package:flutter/material.dart';

class ManageThings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddScaffold(
        title: 'Manage Things',
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.only(top: 30),
            alignment: Alignment.topCenter,
            child: Wrap(
              spacing: 20,
              runSpacing: 20.0,
              children: [
                ActionCard(
                    icon: Icons.track_changes,
                    title: 'Manage Products',
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Category()));
                    }),
                ActionCard(
                    icon: Icons.local_offer,
                    title: 'Manage Offers',
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => OfferList()));
                    }),
                ActionCard(
                    icon: Icons.people,
                    title: 'Manage Customers',
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => UserList()));
                    }),
              ],
            ),
          ),
        ));
  }
}
