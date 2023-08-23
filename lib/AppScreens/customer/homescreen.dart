// import 'package:agrocart/AppScreens/admin/products/product.dart';
// import 'package:agrocart/AppScreens/admin/products/productsList.dart';
// import 'package:agrocart/AppScreens/customer/custom_carousel.dart';
// import 'package:agrocart/backend/api/product_api.dart';
// import 'package:agrocart/backend/notifier/product_notifier.dart';
// import 'package:agrocart/universal/add_scaffold.dart';
// import 'package:agrocart/utils/agrocart.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// bool offerCame = false;
// //List<String> imageList = new List();

// class HomeScreenCustomers extends StatefulWidget {
//   @override
//   _HomeScreenCustomersState createState() => _HomeScreenCustomersState();
// }

// class _HomeScreenCustomersState extends State<HomeScreenCustomers> {
//   @override
//   void initState() {
//     BookNotifier foodNotifier =
//         Provider.of<BookNotifier>(context, listen: false);
//     getOffer(foodNotifier);

//     getBooks(foodNotifier, 'hardware');

//     super.initState();
//   }

//   List<String> images = new List();

//   @override
//   Widget build(BuildContext context) {
//     BookNotifier foodNotifier = Provider.of<BookNotifier>(context);

//     // images.add(
//     //     'http://www.welcomenepal.com/uploads/Lumbini5_tk_buddhajayanti.jpg');
//     // images.add('http://www.welcomenepal.com/uploads/lumbini8.jpg');
//     // images.add('http://www.welcomenepal.com/uploads/lumbini3.jpg');
//     // images.add(
//     //     'http://www.welcomenepal.com/uploads/lumbini4_tk_buddhajayanti.jpg');

//     return AddScaffold(
//         title: 'AgroCart',
//         body: offerCame == false
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Padding(
//                 padding: const EdgeInsets.all(.0),
//                 child: SingleChildScrollView(
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Text(
//                             'Quick Access',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             CategoryChips(
//                                 image: Image.asset('assets/insecticide.png'),
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => ProductsCom(
//                                                 depname: 'pesticides',
//                                               )));
//                                 }),
//                             CategoryChips(
//                                 image: Image.asset('assets/fertilizer.png'),
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => ProductsCom(
//                                                 depname: 'fertilizers',
//                                               )));
//                                 }),
//                             CategoryChips(
//                                 image: Image.asset('assets/seeds.png'),
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => ProductsCom(
//                                                 depname: 'seeds',
//                                               )));
//                                 }),
//                             CategoryChips(
//                                 image: Image.asset('assets/pitchfork.png'),
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => ProductsCom(
//                                                 depname: 'hardware',
//                                               )));
//                                 }),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 18,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Text(
//                             'Recently added',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         CustomCarousel(imageUrls: foodNotifier.imageList),
                       
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Text(
//                             'Hardware product',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
                        
//                         dataGot == false
//                             ? Center(child: CircularProgressIndicator())
//                             : Padding(
//                           padding: const EdgeInsets.all(16.0),
//                               child: GridView.builder(
//                                   shrinkWrap: true,
//                                   //physics:  NeverScrollableScrollPhysics(),
//                                   itemCount: foodNotifier.bookList.length,

//                                   gridDelegate:
//                                       new SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     childAspectRatio: 0.70,
//                                     mainAxisSpacing: 10,
//                                     crossAxisSpacing: 10,
//                                   ),
//                                   itemBuilder: (BuildContext context, int index) {
//                                     print(foodNotifier.bookList.length);
//                                     print(foodNotifier.bookList[index].name);

//                                     return InkWell(
//                                       borderRadius: BorderRadius.circular(8),
//                                       onTap: () {
//                                         foodNotifier.currentBook =
//                                             foodNotifier.bookList[index];
//                                         Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                                 builder: (BuildContext context) {
//                                           return ThingForEdit();
//                                         }));
//                                       },
//                                       child: Ink(
//                                         height:
//                                             (MediaQuery.of(context).size.width /
//                                                 2),
//                                         width:
//                                             (MediaQuery.of(context).size.width /
//                                                 2),
//                                         decoration: BoxDecoration(
//                                           boxShadow:
//                                               AgrocartUniversal.customBoxShadow,
//                                           borderRadius: BorderRadius.circular(8),
//                                           color: Colors.white,
//                                         ),
//                                         child: Column(
//                                           children: <Widget>[
//                                             Container(
//                                               // padding: EdgeInsets.only(top: 15),
//                                               child: Stack(children: <Widget>[
//                                                 Container(
//                                                   height: 190.0,
//                                                   child: ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                       topLeft: Radius.circular(8),
//                                                       topRight:
//                                                           Radius.circular(8),
//                                                     ),
//                                                     child:
//                                                         FadeInImage.assetNetwork(
//                                                       fit: BoxFit.cover,
//                                                       image: foodNotifier
//                                                           .bookList[index].image,
//                                                       placeholder:
//                                                           'assets/yello.jpg',
//                                                     ),

//                                                     // Image.network(
//                                                     //      foodNotifier.bookList[index].image != null
//                                                     //       ? foodNotifier.bookList[index].image
//                                                     //       : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
//                                                     //       fit: BoxFit.cover,
//                                                     // ),
//                                                   ),
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                             topLeft:
//                                                                 Radius.circular(
//                                                                     10.0),
//                                                             topRight:
//                                                                 Radius.circular(
//                                                                     10.0)),
//                                                   ),
//                                                 )
//                                               ]),
//                                             ),
//                                             Container(
//                                               padding: EdgeInsets.only(top: 15),
//                                               child: Text(
//                                                 foodNotifier.bookList[index].name,
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 14.0,
//                                                 ),
//                                               ),
//                                             ),
//                                             Container(
//                                               padding: EdgeInsets.only(top: 5),
//                                               child: Text(
//                                                 '₹ ${foodNotifier.bookList[index].price}',
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 14.0,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   physics: NeverScrollableScrollPhysics(),
//                                 ),
//                             ),
//                         // }
//                         //}),
//                       ]),
//                 ),
//               ));
//   }
// }

// class CategoryChips extends StatelessWidget {
//   final Image image;
//   final Function onPressed;

//   const CategoryChips({
//     Key key,
//     this.onPressed,
//     this.image,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(50),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(50),
//         onTap: onPressed,
//         child: Ink(
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(50),
//               boxShadow: AgrocartUniversal.customBoxShadow),
//           height: 75,
//           width: 75,
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Center(
//               child: Tab(
//                 child: image,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:agrocart/AppScreens/admin/products/product.dart';
import 'package:agrocart/AppScreens/admin/products/productsList.dart';
import 'package:agrocart/AppScreens/customer/custom_carousel.dart';
import 'package:agrocart/backend/api/product_api.dart';
import 'package:agrocart/backend/models/product_model.dart';
import 'package:agrocart/backend/notifier/product_notifier.dart';
import 'package:agrocart/universal/add_scaffold.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

bool offerCame = false;

class HomeScreenCustomers extends StatefulWidget {
  @override
  _HomeScreenCustomersState createState() => _HomeScreenCustomersState();
}

class _HomeScreenCustomersState extends State<HomeScreenCustomers> {
  @override
  void initState() {
    BookNotifier foodNotifier =
        Provider.of<BookNotifier>(context, listen: false);
    getOffer(foodNotifier);
    super.initState();
  }

  List<String> images = new List();

  @override
  Widget build(BuildContext context) {
    BookNotifier foodNotifier = Provider.of<BookNotifier>(context);
    return AddScaffold(
        title: 'AdGroup',
        body: offerCame == false
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(.0),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Quick Access',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Container(
                              height: 75,
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Categories').orderBy('createdAt', descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      if (snapshot.data.documents.length == 0) {
                                        print('in NULL sec');
                                        return Center(
                                          child: Text(
                                            'Option will be displayed here',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        );
                                      } else {
                                        print(snapshot);
                                        print("tempIndex");
                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount:
                                              snapshot.data.documents.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            DocumentSnapshot snapshott =
                                                snapshot.data.documents[index];
                                            print(
                                                "${snapshott.data()['categoryName']}");
                                            return CategoryChips(
                                                image: Image.network(
                                                    snapshott.data()['image']),
                                                onPressed: () {
                                                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductsCom(
                                    depname: snapshott
                                            .data()[
                                        'categoryName'],
                                  )));
                                                });
                                          },
                                          // physics: NeverScrollableScrollPhysics(),
                                        );
                                      }
                                    }
                                  }),
                            ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        foodNotifier.imageList.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'New Offers',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        foodNotifier.imageList.isEmpty
                            ? Container()
                            : CustomCarousel(imageUrls: foodNotifier.imageList),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Best Picks',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Categories')
                                  .doc('wheet')
                                  .collection('Products')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  if (snapshot.data.documents.length == 0) {
                                    return Center(
                                      child: Text(
                                        'You do not have any category',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.documents.length,
                                      gridDelegate:
                                          new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.64,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        print(snapshot.data.documents.length);
                                        DocumentSnapshot snapshott =
                                            snapshot.data.documents[index];

                                        print("${snapshott.data()['count']}");

                                        return InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onTap: () {
                                            foodNotifier.currentBook =
                                                Product.fromMap(
                                                    snapshott.data());
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return ThingForEdit();
                                            }));
                                          },
                                          child: Ink(
                                            height: (MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2),
                                            width: (MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2),
                                            decoration: BoxDecoration(
                                              boxShadow: AgrocartUniversal
                                                  .customBoxShadow,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  // padding: EdgeInsets.only(top: 15),
                                                  child:
                                                      Stack(children: <Widget>[
                                                    Container(
                                                      height: 190.0,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8),
                                                        ),
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          fit: BoxFit.cover,
                                                          image: snapshott
                                                              .data()['image'],
                                                          placeholder: 'assets/placeholder.jpg',
                                                        ),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10.0)),
                                                      ),
                                                    )
                                                  ]),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 15),
                                                  child: Text(
                                                    snapshott.data()['name'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  child: Text(
                                                    '₹ ${snapshott.data()['price']}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      physics: NeverScrollableScrollPhysics(),
                                    );
                                  }
                                }
                              }),
                          // }
                          //}),
                        ),
                      ]),
                ),
              ));
  }
}

class CategoryChips extends StatelessWidget {
  final Image image;
  final Function onPressed;

  const CategoryChips({
    Key key,
    this.onPressed,
    this.image,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onPressed,
          child: Ink(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: AgrocartUniversal.customBoxShadow),
            height: 75,
            width: 75,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Tab(
                  child: image,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
