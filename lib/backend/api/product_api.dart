import 'dart:io';
import 'package:agrocart/AppScreens/admin/add/addOffer.dart';
import 'package:agrocart/AppScreens/admin/add/addProduct.dart';
import 'package:agrocart/AppScreens/admin/dashboard.dart';
import 'package:agrocart/AppScreens/admin/products/productsList.dart';
import 'package:agrocart/AppScreens/customer/homescreen.dart';
import 'package:agrocart/backend/api/user_api.dart';
import 'package:agrocart/backend/models/offerModel.dart';
import 'package:agrocart/backend/models/product_model.dart';
import 'package:agrocart/backend/notifier/product_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

uploadFoodAndImage(Product food, bool isUpdating, PickedFile localFile,
    Function foodUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('Categories/${food.category}/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(File(localFile.path))
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadFood(food, isUpdating, foodUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadFood(food, isUpdating, foodUploaded);
  }
}

_uploadFood(Product food, bool isUpdating, Function foodUploaded,
    {String imageUrl}) async {
  CollectionReference foodRef = FirebaseFirestore.instance
      .collection('Categories')
      .doc(food.category)
      .collection("Products");

  DocumentReference docRef =
      FirebaseFirestore.instance.collection('Categories').doc(food.category);

  if (imageUrl != null) {
    food.image = imageUrl;
  }

  if (isUpdating) {
    food.updatedAt = Timestamp.now();
    //food.userId = currentUser.uid;
    // await foodRef.doc(food.productID).update(food.toMap()).whenComplete(
    //       () => productUploaded = true,
    //     );
    await foodRef.doc(food.productID).update(food.toMap()).then(
          (value) => productUploaded = true,
        );

    foodUploaded(food);
    print('updated food with id: ${food.productID}');
  } else {
    String fChar = food.name[0];
    food.firstChar = fChar;
    print(fChar);
    food.createdAt = Timestamp.now();
    await docRef.update({
      'count': FieldValue.increment(1),
    });
    //food.userId = currentUser.uid;
    // DocumentReference documentRef =
    //     await foodRef.add(food.toMap()).whenComplete(
    //           () => productUploaded = true,
    //         );
    DocumentReference documentRef = await foodRef.add(food.toMap());
    productUploaded = true;

    food.productID = documentRef.id;

    print('uploaded food successfully: ${food.toString()}');

    await documentRef.set(food.toMap(), SetOptions(merge: true));

    foodUploaded(food);
  }
}

//=------------------------
addOffer(
    Offer offer, bool isUpdating, File localFile, Function foodUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('books/OfferImage/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .onComplete
        .catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _offerUpload(offer, isUpdating, foodUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _offerUpload(offer, isUpdating, foodUploaded);
  }
}

_offerUpload(Offer offer, bool isUpdating, Function offerUploaded,
    {String imageUrl}) async {
  CollectionReference offerRef =
      FirebaseFirestore.instance.collection('Offers');

  //User currentUser =  FirebaseAuth.instance.currentUser;
  if (imageUrl != null) {
    offer.image = imageUrl;
  }

  if (isUpdating) {
    offer.updatedAt = Timestamp.now();
    //food.userId = currentUser.uid;
    await offerRef.doc(offer.productID).update(offer.toMap()).whenComplete(
          () => addOffered = true,
        );

    offerUploaded(offer);
    print('updated offer with id: ${offer.productID}');
  } else {
    String fChar = offer.name[0];
    offer.firstChar = fChar;
    print(fChar);
    offer.createdAt = Timestamp.now();
    //food.userId = currentUser.uid;
    DocumentReference documentRef =
        await offerRef.add(offer.toMap()).whenComplete(
              () => addOffered = true,
            );

    offer.productID = documentRef.id;

    print('uploaded offer successfully: ${offer.toString()}');

    await documentRef.set(offer.toMap(), SetOptions(merge: true));

    offerUploaded(offer);
  }
}
//=------------------------

deleteOffer(Offer offer, Function offerDeleted) async {
  if (offer.image != null) {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(offer.image);

    print(storageReference.path);

    await storageReference.delete().then((value) => print('image deleted'));
  }
  await FirebaseFirestore.instance
      .collection('Offers')
      .doc(offer.productID)
      .delete()
      .then((value) => print('Product Deleted'));
  offerDeleted(offer);
}

deleteFood(Product food, Function foodDeleted) async {
  if (food.image != null) {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(food.image);

    print(storageReference.path);

    await storageReference.delete().then((value) => print('image deleted'));
  }
  await FirebaseFirestore.instance
      .collection('Products')
      .doc('Categories')
      .collection(food.category)
      .doc(food.productID)
      .delete()
      .then((value) => print('Product Deleted'));
  foodDeleted(food);
}

getBooks(BookNotifier bookNotifier, String depname) async {
  //heroTag: 'harsh';
  //String dep = depname as String;
  dataGot = false;
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Products')
      .doc('Categories')
      .collection(depname)
      .orderBy('createdAt', descending: true)
      .get();

  List<Product> _bookList = [];

  snapshot.docs.forEach((document) {
    Product book = Product.fromMap(document.data());
    _bookList.add(book);
  });

  bookNotifier.bookList = _bookList;
  //return snapshot;
  dataGot = true;
}

searchResultsList(foodNotifier) {
  List<Product> showResults = [];

  if (searchController.text != "") {
    snapshot.docs.forEach((document) {
      var title = Product.fromMap(document.data()).name.toLowerCase();
      if (title.contains(searchController.text.toLowerCase())) {
        Product book = Product.fromMap(document.data());
        showResults.add(book);
      }

    });
  } else {
    snapshot.docs.forEach((document) {
      Product book = Product.fromMap(document.data());
      showResults.add(book);
    });
    // setState(() {
    //   foodNotifier.bookList = showResults;
    // });
  }
  return foodNotifier.bookList = showResults;
}

getProducts(String depname, foodNotifier) async {
  dataGot = false;
  await FirebaseFirestore.instance
      .collection('Categories')
      .doc(depname)
      .collection("Products")
      .get()
      .then((value) {
    snapshot = value;
    print(value.docs.length);
    dataGot = true;
  });
  searchResultsList(foodNotifier);
  return "complete";
}

//======================
getOffer(BookNotifier bookNotifier) async {
  offerCame = false;
  print('In Api Sec');
  List<Offer> _offerList = [];
  await FirebaseFirestore.instance.collection('Offers').get().then((value) {
    value.docs.forEach((document) {
      Offer offer = Offer.fromMap(document.data());
      print(value.docs.length);
      _offerList.add(offer);
    });
  });
  print('snapshot');
  print(_offerList[0].image);
  bookNotifier.offerList = _offerList;
  List<String> _imageList = [];

  bookNotifier.offerList.forEach((element) {
    _imageList.add(element.image);
    print('length of imageList in forEach Loop');
    print(bookNotifier.imageList.length);
  });
  bookNotifier.imageList = _imageList;
  offerCame = true;
}
//======================

getBooksForFilter(
    BookNotifier bookNotifier, String depname, String filter) async {
  //heroTag: 'harsh';
  //String dep = depname as String;
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection(depname)
      .where('filter', isEqualTo: filter)
      .get();
  print('in Book_Api');
  print(snapshot);

  List<Product> _bookList = [];

  snapshot.docs.forEach((document) {
    Product book = Product.fromMap(document.data());
    _bookList.add(book);
  });

  bookNotifier.bookList = _bookList;
}




