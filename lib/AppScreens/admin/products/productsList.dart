import 'package:agrocart/AppScreens/admin/products/product.dart';
import 'package:agrocart/backend/api/product_api.dart';
import 'package:agrocart/backend/notifier/product_notifier.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String id;
Icon filter = new Icon(Icons.sort);
bool dataGot = false;
Future resultsLoaded;
QuerySnapshot snapshot;
TextEditingController searchController = TextEditingController();

class ProductsCom extends StatefulWidget {
  final String depname;
  const ProductsCom({
    Key key,
    this.depname,
  });

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<ProductsCom> {
  Widget appBarTitle;

  Icon searchIcon = new Icon(Icons.search);
  void initState() {
    BookNotifier foodNotifier =
        Provider.of<BookNotifier>(context, listen: false);
    print(widget.depname);
    appBarTitle = Text(widget.depname);
    getProducts(widget.depname, foodNotifier);
    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchController.clear();
    super.dispose();
  }

  _onSearchChanged() {
    BookNotifier foodNotifier =
        Provider.of<BookNotifier>(context, listen: false);
    searchResultsList(foodNotifier);
  }

  Future<void> _refreshList() async {
    BookNotifier foodNotifier =
        Provider.of<BookNotifier>(context, listen: false);
    getProducts(widget.depname, foodNotifier);
  }

  @override
  Widget build(BuildContext context) {
    BookNotifier foodNotifier = Provider.of<BookNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: appBarTitle,
        iconTheme: new IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
              icon: searchIcon,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (this.searchIcon.icon == Icons.search) {
                    this.searchIcon = new Icon(Icons.close);
                    this.appBarTitle = new TextFormField(
                      cursorColor: Colors.black,
                      controller: searchController,
                      autofocus: true,
                      style: new TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      decoration: new InputDecoration(
                          hintText: "Search...",
                          hintStyle: new TextStyle(color: Colors.grey)),
                    );
                  } else {
                    this.searchIcon = new Icon(Icons.search);
                    this.appBarTitle = new Text(widget.depname);
                  }
                });
              }),
        ],
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: dataGot == false
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshList,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: foodNotifier.bookList.length == 0
                    ? Center(child: Text('No Data'))
                    : GridView.builder(
                        itemCount: foodNotifier.bookList.length,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.64,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          print(foodNotifier.bookList.length);
                          print(foodNotifier.bookList[index].name);

                          return InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              foodNotifier.currentBook =
                                  foodNotifier.bookList[index];
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return ThingForEdit();
                              }));
                            },
                            child: Ink(
                              height: 300,
                              width: (MediaQuery.of(context).size.width / 1),
                              decoration: BoxDecoration(
                                boxShadow: AgrocartUniversal.customBoxShadow,
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    // padding: EdgeInsets.only(top: 15),
                                    child: Stack(children: <Widget>[
                                      Container(
                                        height: 190.0,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                          child: foodNotifier
                                                      .bookList[index].image ==
                                                  null
                                              ? Image.asset(
                                                  'assets/placeholder.jpg')
                                              : FadeInImage.assetNetwork(
                                                  fit: BoxFit.cover,
                                                  image: foodNotifier
                                                      .bookList[index].image,
                                                  placeholder:
                                                      'assets/placeholder.jpg',
                                                ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0)),
                                        ),
                                      )
                                    ]),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text(
                                      foodNotifier.bookList[index].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      '₹ ${foodNotifier.bookList[index].price}',
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
                        physics: ClampingScrollPhysics(),
                      ),
              ),
            ),
    );
  }
}
