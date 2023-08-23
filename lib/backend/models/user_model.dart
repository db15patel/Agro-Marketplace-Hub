import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String displayName;
  String password;
  String phoneNumber;
  String uid;
  String address;
  Timestamp updatedAt;
  String firstChar;
  Timestamp createdAt;

  UserModel();

  UserModel.fromMap(Map<String, dynamic> data) {
    displayName = data['displayName'];
    password = data['password'];
    phoneNumber = data['phoneNumber'];
    uid = data['uid'];
    address = data['address'];
    updatedAt = data['updatedAt'];
    firstChar = data['firstChar'];
    createdAt = data['createdAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'password': password,
      'phoneNumber': phoneNumber,
      'uid': uid,
      'address': address,
      'updatedAt': updatedAt,
      'firstChar': firstChar,
      'createdAt' : createdAt,
    };
  }
}
