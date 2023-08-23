import 'dart:io';
import 'package:agrocart/backend/api/product_api.dart';
import 'package:agrocart/backend/models/product_model.dart';
import 'package:agrocart/backend/notifier/product_notifier.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:agrocart/utils/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

bool productUploaded = true;

class Upload extends StatefulWidget {
  final bool isUpdating;

  Upload({@required this.isUpdating});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController t1 = TextEditingController();

  Product _currentBook;
  String _imageUrl;
  PickedFile _imageFile;
  String _dropDownValue;
  List depList = [];
  bool progress = false;
  final ImagePicker _picker = ImagePicker();
  //User

  @override
  void initState() {
    super.initState();
    BookNotifier bookNotifier =
        Provider.of<BookNotifier>(context, listen: false);
    _getDep();
    if (bookNotifier.currentBook != null) {
      _currentBook = bookNotifier.currentBook;
    } else {
      _currentBook = Product();
    }
    //_imageUrl = bookNotifier.currentBook.image;
    _imageUrl = _currentBook.image;
  }

  _getDep() async {
    setState(() {
      progress = true;
    });
    await FirebaseFirestore.instance
        .collection('Categories')
        .get()
        .then((value) {
      print("in For loop");
      value.docs.forEach((document) {
        var dep = document.data()['categoryName'];
        print(dep);
        depList.add(dep);
      });

      setState(() {
        progress = false;
      });
    });
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text("Image will be Display here");
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Column(
        // alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_imageFile.path),
                fit: BoxFit.cover,
                height: 250,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              //color: Colors.black54,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black,
                  //AgrocartUniversal.contrastColorLight,
                  boxShadow: AgrocartUniversal.customBoxShadow,
                ),
                height: 45,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Change Image',
                    style: TextStyle(
                        color: AgrocartUniversal.contrastColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              onTap: () => _getLocalImage(),
            ),
          ),
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Column(
        // alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _imageUrl,
                fit: BoxFit.cover,
                height: 250,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              //color: Colors.black54,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black,
                  //AgrocartUniversal.contrastColorLight,
                  boxShadow: AgrocartUniversal.customBoxShadow,
                ),
                height: 45,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Change Image',
                    style: TextStyle(
                        color: AgrocartUniversal.contrastColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              onTap: () => _getLocalImage(),
            ),
          ),
        ],
      );
    }
  }

  _getLocalImage() async {
    final imageFile = await _picker.getImage(
        source: ImageSource.gallery, imageQuality: 100, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildtitlefield() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        // controller: t1,
        initialValue: _currentBook.name,
        cursorColor: AgrocartUniversal.contrastColor,
        decoration: InputDecoration(
            labelText: 'Name',
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
        validator: (String value) {
          if (value == null) {
            return 'Name is required';
          }
          return null;
        },
        onSaved: (value) {
          _currentBook.name = value;
        },
      ),
    );
  }

  Widget _buildauthorfield() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        initialValue: _currentBook.company,
        cursorColor: AgrocartUniversal.contrastColor,
        decoration: InputDecoration(
            labelText: 'Company',
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
        validator: (String value) {
          if (value == null) {
            return 'Company is required';
          }
          return null;
        },
        onSaved: (value) {
          _currentBook.company = value;
        },
      ),
    );
  }

  Widget _buildpricefield() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        initialValue: _currentBook.price,
        cursorColor: AgrocartUniversal.contrastColor,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: 'Price',
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
        validator: (String value) {
          if (value == null) {
            return 'Price Can not be empty';
          }
          return null;
        },
        onSaved: (value) {
          _currentBook.price = value;
        },
      ),
    );
  }

  Widget _buildaboutfield() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        initialValue: _currentBook.about,
        cursorColor: AgrocartUniversal.contrastColor,
        decoration: InputDecoration(
            labelText: 'About Product',
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
        validator: (String value) {
          if (value == null) {
            return 'About is required';
          }
          return null;
        },
        onSaved: (value) {
          _currentBook.about = value;
        },
      ),
    );
  }

  Widget _buildphonenofield() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        initialValue: _currentBook.number,
        cursorColor: AgrocartUniversal.contrastColor,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: 'phoneno',
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
        validator: (String value) {
          if (value == null) {
            return 'Phone no is required';
          }
          if (value.length < 0 || value.length > 10) {
            return 'Phone no must be 10 digit';
          }
          return null;
        },
        onSaved: (value) {
          _currentBook.number = value;
        },
      ),
    );
  }

  Widget _buildusernamefield() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        initialValue: _currentBook.weight,
        cursorColor: AgrocartUniversal.contrastColor,

        decoration: InputDecoration(
            labelText: 'Weight',
            labelStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
        // validator: (String value) {
        //   if (value == null) {
        //     return 'weight is required';
        //   }
        //   if (value.length < 3 || value.length > 20) {
        //     return 'weight must be more than 3 and less than 20';
        //   }
        // },
        validator: (value) {
          if (value == null) {
            return 'Weight is required';
          }
          return null;
        },
        onSaved: (value) {
          _currentBook.weight = value;
          // _currentBook.userId = authNotifier.user.email;
        },
      ),
    );
  }

  Widget _builddepartmentfield() {
    return Container(
      padding: EdgeInsets.all(10),
      child: DropdownButton(
        iconEnabledColor: Colors.grey,
        hint: _dropDownValue == null
            ? Text('Categories',
             style: TextStyle(fontFamily: 'GoogleSans')
            )
            : Text(
                _dropDownValue,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
        isExpanded: true,
        value: _currentBook.category,
        iconSize: 30.0,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        items: depList.map(
          (val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          },
        ).toList(),
        
        // ['pesticides', 'fertilizers', 'seeds', 'hardware'].map(
        //   (val) {
        //     return DropdownMenuItem<String>(
        //       value: val,
        //       child: Text(val),
        //     );
        //   },
        // ).toList(),
        onChanged: (val) {
          setState(
            () {
              _dropDownValue = val;
              _currentBook.category = val;
            },
          );
        },
      ),
    );
  }

  _onBookUploaded(Product book) {
    // BookNotifier foodNotifier =
    //     Provider.of<BookNotifier>(context, listen: false);
    // if (!widget.isUpdating) {
    //   foodNotifier.addBook(book);
    // } else {}
    // Navigator.pop(context);

    BookNotifier foodNotifier =
        Provider.of<BookNotifier>(context, listen: false);
    foodNotifier.addBook(book);
    Navigator.pop(context);
    widget.isUpdating ? Navigator.pop(context) : {};
    widget.isUpdating ? Navigator.pop(context) : {};
  }

  _saveBook() {
    print('saveFood Called');
    if (!_formkey.currentState.validate() ||
        (_imageFile == null && _imageUrl == null)) {
      print(_formkey.currentState.validate());

      return;
    }

    _formkey.currentState.save();

    print('form saved');

    //_currentFood.subIngredients = _subingredients;
    print('form saved');

    uploadFoodAndImage(
        _currentBook, widget.isUpdating, _imageFile, _onBookUploaded);

    print("name: ${_currentBook.name}");
    print("author: ${_currentBook.company}");
    print("price: ${_currentBook.price.toString()}");
    print("about: ${_currentBook.about}");
    print("username: ${_currentBook.weight.toString()}");
    print("number: ${_currentBook.number.toString()}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.isUpdating ? 'Edit Product' : "Add Product",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: progress == true
          ? Center(child: CircularProgressIndicator())
          : Stack(
            children: [
              SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
                key: _formkey,
                autovalidate: true,
                child: Column(children: <Widget>[
                  _showImage(),
                  _imageFile == null && _imageUrl == null
                      ? Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.02),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            //color: Colors.black54,
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.black,
                                //AgrocartUniversal.contrastColorLight,
                                boxShadow: AgrocartUniversal.customBoxShadow,
                              ),
                              height: 45,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Add Image',
                                  style: TextStyle(
                                      color: AgrocartUniversal.contrastColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            onTap: () => _getLocalImage(),
                          ),
                        )
                      : SizedBox(height: 0),
                      !widget.isUpdating ?  Text('300 x 300 px is recommended', style: TextStyle(
                        color: Colors.grey
                      ),) : Container(),
                  _builddepartmentfield(),
                  _buildtitlefield(),
                  _buildauthorfield(),
                  _buildpricefield(),
                  _buildaboutfield(),
                  _buildusernamefield(),
                  _buildphonenofield(),
                  SizedBox(
                    height: 10,
                  ),
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
                                  'Upload Product',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          productUploaded = false;
                        });
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _saveBook();
                      },
                    ),
                  ),
                ])),
      ),

      productUploaded == false
                    ? Positioned(child: Center(child: Loading()))
                    : Container(),
            ],
          ),
    );
  }
}
