import 'dart:collection';
import 'package:agrocart/backend/models/offerModel.dart';
import 'package:agrocart/backend/models/product_model.dart';
import 'package:flutter/cupertino.dart';

class BookNotifier with ChangeNotifier {
  List<Product> _bookList = [];
  List<Offer> _offerList = [];
  List<String> _imageList = [];

  Product _currentBook;
  Offer _currentOffer;
  UnmodifiableListView<Product> get bookList => UnmodifiableListView(_bookList);
  UnmodifiableListView<Offer> get offerList => UnmodifiableListView(_offerList);
  UnmodifiableListView<String> get imageList =>
      UnmodifiableListView(_imageList);

  Product get currentBook => _currentBook;
  Offer get currentOffer => _currentOffer;

  set bookList(List<Product> bookList) {
    _bookList = bookList;
    notifyListeners();
  }

  set offerList(List<Offer> offerList) {
    _offerList = offerList;
    notifyListeners();
  }

    set imageList(List<String> imageList) {
    _imageList = imageList;
    notifyListeners();
  }

  addBook(Product book) {
    _bookList.insert(0, book);
    notifyListeners();
  }

  addOffer(Offer offer) {
    _offerList.insert(0, offer);
    notifyListeners();
  }

   addImage(String image) {
    _imageList.insert(0, image);
    notifyListeners();
  }

  set currentBook(Product book) {
    _currentBook = book;
    notifyListeners();
  }

  set currentOffer(Offer offer) {
    _currentOffer = offer;
    notifyListeners();
  }

  deleteFood(Product food) {
    _bookList.removeWhere((_food) => _food.productID == food.productID);
    notifyListeners();
  }

  deleteOffer(Offer offer) {
    _offerList.removeWhere((_offer) => _offer.productID == offer.productID);
    notifyListeners();
  }
}
