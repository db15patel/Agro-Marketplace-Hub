import 'dart:core' as prefix1;
import 'dart:core';
import 'dart:ffi';
import 'package:agrocart/AppScreens/admin/add/addProduct.dart';
import 'package:agrocart/AppScreens/admin/products/dialouge.dart';
import 'package:agrocart/backend/api/product_api.dart';
import 'package:agrocart/backend/models/product_model.dart';
import 'package:agrocart/backend/notifier/auth_notofier.dart';
import 'package:agrocart/backend/notifier/product_notifier.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Widget divider() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
    child: Container(
      width: 0.8,
    ),
  );
}

class ThingForEdit extends StatefulWidget {
  @override
  _ThingState createState() => _ThingState();
}

class _ThingState extends State<ThingForEdit> {
  Icon searchIcon = new Icon(Icons.search);
  Icon bookIcon = new Icon(Icons.bookmark);

  Future<void> _launched;
  String _phone;
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void initState() {
    BookNotifier foodNotifier =
        Provider.of<BookNotifier>(context, listen: false);
    _phone = foodNotifier.currentBook.number.toString();
    super.initState();
  }



  Future<bool> _disposee() async {
    BookNotifier foodNotifier =
        Provider.of<BookNotifier>(context, listen: false);
    foodNotifier.currentBook = null;
    Navigator.of(context).pop(true);
    return true;
    //return null;
  }

  @override
  Widget build(BuildContext context) {
    BookNotifier foodNotifier = Provider.of<BookNotifier>(context);
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    double width = MediaQuery.of(context).size.width;

    _onFoodDeleted(Product food) {
      Navigator.pop(context);
      foodNotifier.deleteFood(food);
      foodNotifier.currentBook = null;
    }

    return foodNotifier.currentBook == null
        ? Container()
        : Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 345.0,
                floating: false,
                pinned: true,
                snap: false,
                leading: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    // foodNotifier.currentBook = null;
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                title: Text(
                        AgrocartUniversal.adminList
                                        .contains(authNotifier.userId)
                            ? 'Edit'
                            : 'Product'),
              
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                      background: Align(
                        alignment: Alignment.bottomCenter,
                          child: Image.network(
                          foodNotifier.currentBook.image != null
                              ? foodNotifier.currentBook.image
                              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                              height: 290,
                              
                        ),
                      ),
                ),
              ),
              SliverFixedExtentList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: 50,
                        child: ListTile(
                          title: Text(foodNotifier.currentBook.name ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              )),
                          trailing: Text(
                              '₹ ${foodNotifier.currentBook.price}' ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              )),
                          subtitle: Text(
                              foodNotifier.currentBook.weight.toString() ??
                                  '',
                              style: TextStyle()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 11, bottom: 11),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: 50,
                        child: ListTile(
                          title: Text('About',
                              style: TextStyle(
                                fontSize: 18,
                              )),
                          subtitle: Text(
                              foodNotifier.currentBook.about ?? '',
                              style: TextStyle()),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 11, bottom: 11),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: 70,
                        child: ListTile(
                          title: Text('Company',
                              style: TextStyle(
                                fontSize: 18,
                              )),
                          subtitle: Text(
                              foodNotifier.currentBook.company ?? '',
                              style: TextStyle()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 11, bottom: 11),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        height: 70,
                        child: ListTile(
                          title: Text('Contact here',
                              style: TextStyle(
                                fontSize: 18,
                              )),
                          subtitle: Text(
                              foodNotifier.currentBook.number.toString() ??
                                  '',
                              style: TextStyle()),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 11, bottom: 11),
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     color: Colors.white,
                    //     height: 70,
                    //     child: ListTile(
                    //       leading: Icon(
                    //         Icons.redeem,
                    //         color: AgrocartUniversal.contrastColor,
                    //         size: 35,
                    //       ),
                    //       title: Text('Rewards can get from this product',
                    //           style: TextStyle(
                    //             fontSize: 15,
                    //           )),
                    //       subtitle: Text('I will Change this!',
                    //           style: TextStyle()),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                          padding: EdgeInsets.only(top: 11, bottom: 11),
                          child: Container(
                            //alignment: Alignment.center,
                            height: 70,
                            child: ListTile(
                              leading: Icon(
                                Icons.redeem,
                                color: Colors.grey[400],
                                size: 35,
                              ),
                              title: Text('Purchase products to get rewards',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[400],
                                  )),
                            ),
                          ),
                        ),

                    //SizedBox(height: 10,)
                  ]),
                  itemExtent: 140.0)
            ],
          ),
          bottomNavigationBar: Material(
            elevation: 15,
            child: Container(
                decoration: BoxDecoration(color: Colors.white),
                height: 55.0,
                width: MediaQuery.of(context).size.width,
                child: AgrocartUniversal.adminList.contains(authNotifier.userId)
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            // Container(
                            //     alignment: Alignment.center,
                            //     height: 60,
                            //     width: width * 0.5,
                            //     child: InkWell(
                            //       onTap: () {
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) => Upload(
                            //                       isUpdating: true,
                            //                     )));
                            //       },
                            //       child: Text(
                            //         'EDIT',
                            //         style: TextStyle(
                            //             fontSize: 16.0,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     )),
                            InkWell(
                                enableFeedback: true,
                                hoverColor: AgrocartUniversal.contrastColor,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Upload(
                                                isUpdating: true,
                                              )));
                                },
                                child: Ink(
                                    height: 60,
                                    width: width * 0.5,
                                    child: Center(
                                      child: Text(
                                        'EDIT',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ),
                            // Container(
                            //   alignment: Alignment.center,
                            //   height: 60,
                            //   width: width * 0.5,
                            //   color: Colors.redAccent,
                            //   child: InkWell(
                            //     onTap: () async {
                            //       final action = await Dialogs.yesAbortDialog(
                            //           context,
                            //           'Confirm',
                            //           'Are you sure want to delete this Product?');
                            //       if (action == DialogAction.yes) {
                            //         setState(() {
                            //           deleteFood(foodNotifier.currentBook,
                            //               _onFoodDeleted);
                            //           toast();
                            //         });
                            //       } else {
                            //         // setState(
                            //         //     () => Navigator.of(context).pop());
                            //       }
                            //     },
                            //     child: Text(
                            //       'DELETE',
                            //       style: TextStyle(
                            //           fontSize: 16.0,
                            //           color: Colors.white,
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // ),
                            InkWell(
                                onTap: () async {
                                  final action = await Dialogs.yesAbortDialog(
                                      context,
                                      'Confirm',
                                      'Are you sure want to delete this Product?');
                                  if (action == DialogAction.yes) {
                                    setState(() {
                                      deleteFood(foodNotifier.currentBook,
                                          _onFoodDeleted);
                                      toast();
                                    });
                                  } else {
                                    
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 60,
                                  width: width * 0.5,
                                  color: Colors.redAccent,
                                  child: Text(
                                    'DELETE',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ])
                    : InkWell(
                          onTap: () async {
                            final action = await Dialogs.yesAbortDialog(
                                context,
                                'Confirm',
                                'Are you sure want to contact for this Product?');
                            if (action == DialogAction.yes) {
                              setState(() {
                                _launched = _makePhoneCall('tel:$_phone');
                              });
                            } else {
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: width * 0.5,
                            color: AgrocartUniversal.contrastColor,
                            child: InkWell(
                              child: Text(
                                'Contact now',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    // Row(
                    //     children: [
                    //       Container(
                    //           alignment: Alignment.center,
                    //           height: 60,
                    //           width: width * 0.5,
                    //           child: InkWell(
                    //             onTap: () {
                    //               // Navigator.push(
                    //               //     context,
                    //               //     MaterialPageRoute(
                    //               //         builder: (context) => Upload(
                    //               //   isUpdating: true,
                    //               // )));
                    //             },
                    //             child: Text(
                    //               'Add to cart',
                    //               style: TextStyle(
                    //                 fontSize: 16.0,
                    //               ),
                    //             ),
                    //           )),
                    //       Container(
                    //         alignment: Alignment.center,
                    //         height: 60,
                    //         width: width * 0.5,
                    //         color: AgrocartUniversal.contrastColor,
                    //         child: InkWell(
                    //           onTap: () async {
                    //             final action = await Dialogs.yesAbortDialog(
                    //                 context,
                    //                 'Confirm',
                    //                 'Are you sure want to contact for this Product?');
                    //             if (action == DialogAction.yes) {
                    //               setState(() {
                    //                 _launched =
                    //                     _makePhoneCall('tel:$_phone');
                    //               });
                    //             } else {
                    //               // setState(
                    //               //     () => Navigator.of(context).pop());
                    //             }
                    //           },
                    //           child: Text(
                    //             'Contact now',
                    //             style: TextStyle(
                    //               fontSize: 16.0,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   )
                      
                      ),
          ),
        );
  }

  void toast() {
    Fluttertoast.showToast(
        msg: "Product Deleted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
