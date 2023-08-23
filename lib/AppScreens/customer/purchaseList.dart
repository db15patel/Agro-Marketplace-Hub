import 'package:agrocart/AppScreens/admin/users/purchaseHistory.dart';
import 'package:agrocart/backend/notifier/auth_notofier.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PurchaseList extends StatefulWidget {
  final String uniqueID;
  PurchaseList(this.uniqueID);
  @override
  _PurchaseListState createState() => _PurchaseListState();
}

class _PurchaseListState extends State<PurchaseList> {
  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    AuthNotifier authnotifierr = Provider.of<AuthNotifier>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Purchase History'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.uniqueID)
                    .collection('purchaseHistory')
                    .orderBy('createdAt', descending: true)
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
                          'You have not made any purchases',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      );
                    } else {
                      print(snapshot);
                      print("tempIndex");
                      return
                          //print(categories[tempIndex]);

                          ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot snapshott =
                              snapshot.data.documents[index];
                          DateTime date =
                              snapshott.data()['createdAt'].toDate();
                          print(date);
                          final String formatted = formatter.format(date);
                          print(formatted);
                          print("${snapshott.data()['note']}");
                          return UniCard(
                              title: snapshott.data()['productName'],
                              price: snapshott.data()['amount'],
                              totalPrice: snapshott.data()['totalAmount'],
                              quantity: snapshott.data()['quantity'],
                              date: formatted,
                              onTap: AgrocartUniversal.adminList
                                      .contains(authnotifierr.userId)
                                  ? () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PurchaseHistory(
                                                    widget.uniqueID,
                                                    snapshott,
                                                    true,
                                                  )));
                                    }
                                  : () {});
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

class UniCard extends StatelessWidget {
  final String title;
  final String price;
  final String totalPrice;
  final String quantity;
  final String date;
  final Function onTap;

  UniCard(
      {Key key,
      this.title,
      this.price,
      this.totalPrice,
      this.quantity,
      this.date,
      this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    print(authNotifier.userId);
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 11, right: 11, bottom: 7),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: AgrocartUniversal.customBoxShadow,
          ),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      'Purchase Quantity ',
                      style: TextStyle(
                        color: AgrocartUniversal.contrastColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      quantity,
                      style: TextStyle(
                          color: AgrocartUniversal.contrastColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      'Unit Price ',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      '₹$price',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      'Total Price ',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      '₹${totalPrice.toString()}',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    date,
                    style: TextStyle(
                        color: AgrocartUniversal.contrastColor,
                        fontSize: 15),
                  ),
                  decoration: BoxDecoration(
                    color: AgrocartUniversal.contrastColorLight,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
