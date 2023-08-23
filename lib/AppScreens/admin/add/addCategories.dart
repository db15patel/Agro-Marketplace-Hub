import 'package:agrocart/utils/agrocart.dart';
import 'package:agrocart/utils/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddCategories extends StatefulWidget {
  AddCategories();
  @override
  _AddCategoriesState createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool progress;
  String categoryName;
  Timestamp createdAt;
  String _imageUrl;
  File _imageFile;

  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Center(child: Text("Image will be displayed here"));
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Column(
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
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black,
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
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black,
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

  Widget _buildCategoryField() {
    return Container(
      margin: EdgeInsets.all(8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Category name",
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
            return 'Category name is required';
          }

          return null;
        },
        onSaved: (String value) {
          categoryName = value;
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
          'Add Category',
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
                                  boxShadow:
                                      AgrocartUniversal.customBoxShadow,
                                ),
                                height: 45,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Add Image',
                                    style: TextStyle(
                                        color:
                                            AgrocartUniversal.contrastColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              onTap: () => _getLocalImage(),
                            ),
                          )
                        : SizedBox(height: 0),

                    Center(
                      child: Text(
                        'Icons recommended (PNG, 256 or 512 px)\n Color code: #f8bc05',textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    _buildCategoryField(),
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
                            child:
                              
                                Text(
                              'Add Category',
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
                          if (!_formKey.currentState.validate()|| (_imageFile == null)) {
                            print(_formKey.currentState.validate());
                            return;
                          } else {
                            setState(() {
                              progress = true;
                            });
                            CollectionReference userRef = FirebaseFirestore
                                .instance
                                .collection("Categories");

                            _formKey.currentState.save();

                            print("uploading image");

                            var fileExtension = path.extension(_imageFile.path);
                            print(fileExtension);

                            var uuid = Uuid().v4();

                            final StorageReference firebaseStorageRef =
                                FirebaseStorage.instance
                                    .ref()
                                    .child('categoryImage/$uuid$fileExtension');

                            await firebaseStorageRef
                                .putFile(_imageFile)
                                .onComplete
                                .catchError((onError) {
                              print(onError);
                              return false;
                            });

                            String url =
                                await firebaseStorageRef.getDownloadURL();
                            print("download url: $url");

                            print('form saved');
                            createdAt = Timestamp.now();

                            int count = 0;

                            await userRef.doc(categoryName).set({
                              'categoryName': categoryName,
                              'createdAt': createdAt,
                              'image': url,
                              'count': count,
                            }).then((value) {
                              setState(() {
                                progress = false;
                              });
                              showDialog(
                                context: context,
                                builder: (context) => new AlertDialog(
                                  title: new Text('Added'),
                                  content: new Text('Category has been added!'),
                                  actions: <Widget>[
                                    new FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: new Text('ok',  style: TextStyle(color: AgrocartUniversal.contrastColor)),
                                    ),
                                  ],
                                ),
                              );
                            });
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
    );
  }
}
