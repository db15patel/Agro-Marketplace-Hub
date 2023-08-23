import 'package:agrocart/backend/models/purchase_model.dart';
import 'package:agrocart/utils/dialouge.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:agrocart/utils/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PurchaseHistory extends StatefulWidget {
  final String uniqueID;
  final DocumentSnapshot snapshot;
  final bool isUpdating;
  PurchaseHistory(this.uniqueID, this.snapshot, this.isUpdating);
  @override
  _PurchaseHistoryState createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PurchaseModel productModel = PurchaseModel();
  String oldValue;
  bool progress;

  @override
  void initState() {
    super.initState();
    if (!widget.isUpdating) {}
    if (widget.snapshot != null) {
      productModel = PurchaseModel.fromMap(widget.snapshot.data());
    } else {
      productModel = PurchaseModel();
    }
  }

  Widget _buildProductNameField() {
    return Container(
      margin: EdgeInsets.all(8),
      child: TextFormField(
        initialValue: productModel.productName,
        decoration: InputDecoration(
          labelText: "ProductName",
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: new UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
// and:
          focusedBorder: new UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 17, color: Colors.black),
        cursorColor: AgrocartUniversal.contrastColor,
        validator: (String value) {
          if (value.isEmpty) {
            return 'ProductName is required';
          }

          return null;
        },
        onSaved: (String value) {
          productModel.productName = value;
        },
      ),
    );
  }

  Widget _buildQuantityfield() {
    return Container(
      margin: EdgeInsets.all(8),
      child: TextFormField(
        initialValue: productModel.quantity,
        cursorColor: AgrocartUniversal.contrastColor,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: 'Quantity',
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Quantity is required';
          }
          return null;
        },
        onSaved: (value) {
          productModel.quantity = value;
        },
      ),
    );
  }

  Widget _buildamountfield() {
    return Container(
      margin: EdgeInsets.all(8),
      child: TextFormField(
        initialValue: productModel.amount,
        cursorColor: AgrocartUniversal.contrastColor,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: 'Amount',
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Amount is required';
          }
          return null;
        },
        onSaved: (value) {
          productModel.amount = value;
          productModel.totalAmount =
              (double.parse(productModel.quantity) * double.parse(value))
                  .toString();
          print('Total amount : ${productModel.totalAmount}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          !widget.isUpdating
              ? 'Add Purchase details'
              : 'Update Purchase details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProductNameField(),
                    _buildQuantityfield(),
                    _buildamountfield(),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.04,
                          top: MediaQuery.of(context).size.width * 0.04,
                          right: MediaQuery.of(context).size.width * 0.04,
                          bottom: MediaQuery.of(context).size.width * 0.1),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        //color: Colors.black54,
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AgrocartUniversal.contrastColor,
                            //AgrocartUniversal.contrastColorLight,
                            boxShadow: AgrocartUniversal.customBoxShadow,
                          ),
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              !widget.isUpdating == true
                                  ? 'Add Purchase details'
                                  : 'Update Purchase details',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          // _saveBook();
                          if (!_formKey.currentState.validate()) {
                            print(_formKey.currentState.validate());
                            return;
                          } else {
                            setState(() {
                              progress = true;
                            });

                            CollectionReference userRefRewardHistory =
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(widget.uniqueID)
                                    .collection('purchaseHistory');
                            _formKey.currentState.save();

                            if (!widget.isUpdating) {
                              print('form saved');
                              productModel.createdAt = Timestamp.now();

                              DocumentReference documentRef =
                                  await userRefRewardHistory
                                      .add(productModel.toMap());

                              productModel.purchaseId = documentRef.id;

                              print(
                                  'Uploaded History successfully: ${productModel.toString()}');

                              await documentRef
                                  .set(productModel.toMap(),
                                      SetOptions(merge: true))
                                  .then((value) {
                                setState(() {
                                  progress = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (context) => new AlertDialog(
                                    title: new Text('Added'),
                                    content: new Text(
                                        'Purchase details has been added!'),
                                    actions: <Widget>[
                                      new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: new Text('ok',
                                            style: TextStyle(
                                                color: AgrocartUniversal
                                                    .contrastColor)),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            } else {
                              await userRefRewardHistory
                                  .doc(productModel.purchaseId)
                                  .update(productModel.toMap())
                                  .then((value) {
                                setState(() {
                                  progress = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (context) => new AlertDialog(
                                    title: new Text('Updated'),
                                    content: new Text(
                                        'Purchase details has been Updated!'),
                                    actions: <Widget>[
                                      new FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: new Text('ok',
                                            style: TextStyle(
                                                color: AgrocartUniversal
                                                    .contrastColor)),
                                      ),
                                    ],
                                  ),
                                );
                              }).catchError((error) => showDialog(
                                        context: context,
                                        builder: (context) => new AlertDialog(
                                          title: new Text('Error'),
                                          content: new Text(
                                              'Purchase details has not been updated! $error'),
                                          actions: <Widget>[
                                            new FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                              child: new Text('ok',
                                                  style: TextStyle(
                                                      color: AgrocartUniversal
                                                          .contrastColor)),
                                            ),
                                          ],
                                        ),
                                      ));
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              progress == true
                  ? Positioned(child: Center(child: Loading()))
                  : Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        // elevation: 15,
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          height: 55.0,
          width: MediaQuery.of(context).size.width,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                !widget.isUpdating == true
                    ? Container()
                    : Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.redAccent,
                        child: InkWell(
                          onTap: () async {
                            final action = await Dialogs.yesAbortDialog(
                                context,
                                'Confirm',
                                'Are you sure want to delete this History?');
                            if (action == DialogAction.yes) {
                              setState(() {
                                progress = true;
                              });

                              CollectionReference userRefRewardHistory =
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(widget.uniqueID)
                                      .collection('purchaseHistory');

                              await userRefRewardHistory
                                  .doc(productModel.purchaseId)
                                  .delete()
                                  .then((value) => setState(() {
                                        progress = false;
                                        Navigator.of(context).pop();
                                      }));
                              // });
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
}
