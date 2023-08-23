import 'dart:io';
import 'package:agrocart/backend/api/product_api.dart';
import 'package:agrocart/backend/models/offerModel.dart';
import 'package:agrocart/backend/models/product_model.dart';
import 'package:agrocart/backend/notifier/product_notifier.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

bool addOffered = true;

class AddOffer extends StatefulWidget {
  final bool isUpdating;
  final DocumentSnapshot snapshot;

  AddOffer({@required this.isUpdating, this.snapshot});
  @override
  _AddOfferState createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Offer _currentOffer;
  String _imageUrl;
  File _imageFile;
  String _dropDownValue;
  //User

  @override
  void initState() {
    super.initState();
    // if (!widget.isUpdating) {
    //   //t1.dispose();
    // }

    if (widget.snapshot  != null) {
      _currentOffer = Offer.fromMap(widget.snapshot.data());
    } else {
      _currentOffer = Offer();
    }
    _imageUrl = _currentOffer.image;
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
                _imageFile,
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
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

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
        initialValue: _currentOffer.name,
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
          _currentOffer.name = value;
        },
      ),
    );
  }

  Widget _buildCompanyField() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        initialValue: _currentOffer.company,
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
          _currentOffer.company = value;
        },
      ),
    );
  }

  Widget _buildpricefield() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        initialValue: _currentOffer.price,
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
          _currentOffer.price = value;
        },
      ),
    );
  }

  Widget _buildaboutfield() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        initialValue: _currentOffer.about,
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
          _currentOffer.about = value;
        },
      ),
    );
  }

  Widget _buildphonenofield() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        initialValue: _currentOffer.number,
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
          _currentOffer.number = value;
        },
      ),
    );
  }

  Widget _buildWeightField() {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        initialValue: _currentOffer.weight,
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
          _currentOffer.weight = value;
          // _currentBook.userId = authNotifier.user.email;
        },
      ),
    );
  }

  Widget _buildCategoriesField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: DropdownButton(
        iconEnabledColor: Colors.grey,
        hint: _dropDownValue == null
            ? Text('Categories')
            : Text(
                _dropDownValue,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
        isExpanded: true,
        iconSize: 30.0,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        items: ['pesticides', 'fertilizers', 'seeds', 'hardware'].map(
          (val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          },
        ).toList(),
        onChanged: (val) {
          setState(
            () {
              _dropDownValue = val;
              _currentOffer.category = val;
            },
          );
        },
      ),
    );
  }

  _onBookAddOffered(Offer offer) {
    BookNotifier foodNotifier =
        Provider.of<BookNotifier>(context, listen: false);
    foodNotifier.addOffer(offer);
    Navigator.pop(context);
  }

  _saveBook() {
    print('saveFood Called');
    if (!_formkey.currentState.validate()) {
      return;
    }

    _formkey.currentState.save();

    print('form saved');

    //_currentFood.subIngredients = _subingredients;

    addOffer(
        _currentOffer, widget.isUpdating, _imageFile, _onBookAddOffered);

    print("name: ${_currentOffer.name}");
    print("author: ${_currentOffer.company}");
    print("price: ${_currentOffer.price.toString()}");
    print("about: ${_currentOffer.about}");
    print("username: ${_currentOffer.weight.toString()}");
    print("number: ${_currentOffer.number.toString()}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.isUpdating ? 'Edit Product' : "AddOffer Product",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
             // _buildCategoriesField(),
              _buildtitlefield(),
              //_buildCompanyField(),
              // _buildpricefield(),
              _buildaboutfield(),
              // _buildWeightField(),
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
                      child: addOffered == false
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'AddOffer Product',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                            ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      addOffered = false;
                    });
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _saveBook();
                  },
                ),
              ),
            ])),
      ),
    );
  }
}
