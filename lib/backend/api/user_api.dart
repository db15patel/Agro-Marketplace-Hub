import 'dart:core' as prefix0;
import 'dart:core';
import 'package:agrocart/AppScreens/admin/users/userList.dart';
import 'package:agrocart/AppScreens/initialPages/login.dart';
import 'package:agrocart/backend/models/createUser_model.dart';
import 'package:agrocart/backend/models/dashboardModel.dart';
import 'package:agrocart/backend/models/user_model.dart';
import 'package:agrocart/backend/notifier/auth_notofier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

DashBoardModel dashBoard = DashBoardModel();

//SignIn
signIn(PhoneAuthCredential credential, UserModel userrr,
    AuthNotifier authNotifier) async {
  await Firebase.initializeApp();
  await FirebaseAuth.instance
      .signInWithCredential(credential)
      .then((authResult) {
    if (authMode == AuthMode.Signup) {
      addUserData(userrr);
    } else {}
    authNotifier.setUser(authResult.user);
  });
  //await signup(userrr, authNotifier);
}

signInWithOTP(
    smsCode, verId, UserModel userrr, AuthNotifier authNotifier) async {
  await Firebase.initializeApp();
  PhoneAuthCredential phoneAuthCredential =
      PhoneAuthProvider.credential(smsCode: smsCode, verificationId: verId);
  print('Testing chal raha hai');
  print(phoneAuthCredential.smsCode);
  print(phoneAuthCredential.verificationId);
  signIn(phoneAuthCredential, userrr, authNotifier);
}

//Signout api
void signout(AuthNotifier authNotifier) async {
  await Firebase.initializeApp();
  await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));
  authNotifier.setUser(null);
}

//check user is logged in or not
initializeCurrentUser(AuthNotifier authNotifier) async {
  await Firebase.initializeApp();
  waitingHomeScreen = false;
  User firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser != null) {
    authNotifier.setUser(firebaseUser);
  }
  waitingHomeScreen = true;
}

Future addUserData(UserModel user) async {
  //prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  final ref = FirebaseFirestore.instance.collection("users");
  User firebaseUser = FirebaseAuth.instance.currentUser;
  print("Uid:$firebaseUser.uid");
  //await prefs.setString('id', firebaseUser.uid);
  user.uid = firebaseUser.uid;
  user.password = 'Ramdom le raha hu';
  user.createdAt = Timestamp.now();
  String fChar = user.displayName[0];
  user.firstChar = fChar;
  return await ref.doc(firebaseUser.uid).set(user.toMap());
}

Future addUserDataAndUpdate(CreateUserModel user, bool isUpdating) async {
  //prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  final ref = FirebaseFirestore.instance.collection("users");
  User firebaseUser = await FirebaseAuth.instance.currentUser;
  print("Uid:$firebaseUser.uid");
  //await prefs.setString('id', firebaseUser.uid);
  user.uid = firebaseUser.uid;
  return await ref.doc(firebaseUser.uid).set(user.toMap());
}

updateUserData(
  CreateUserModel user,
  Function foodUploaded,
) async {
  CollectionReference foodRef = FirebaseFirestore.instance.collection('users');
  user.updatedAt = Timestamp.now();
  //food.userId = currentUser.uid;
  String fChar = user.displayName[0];
  print(fChar);
  print(user.uid);
  user.firstChar = fChar;
  await foodRef.doc(user.uid).update(user.toMap());

  foodUploaded(user);
  print('Updated User with id: ${user.uid}');
}

getUsers(AuthNotifier authnotifier) async {
  userGot = false;
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').get();

  List<CreateUserModel> _userList = [];

  snapshot.docs.forEach((document) {
    CreateUserModel book = CreateUserModel.fromMap(document.data());
    _userList.add(book);
  });

  authnotifier.userListt = _userList;
  dashBoard.totalUsers = snapshot.docs.length;
  //return snapshot;
  userGot = true;
}

signup(
  CreateUserModel user,
  AuthNotifier authNotifier,
) async {
  await Firebase.initializeApp();
  addUserDataNew(user);
}

Future addUserDataNew(CreateUserModel user) async {
  //prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  final ref = FirebaseFirestore.instance.collection("newUsers");
  //User firebaseUser = await FirebaseAuth.instance.currentUser;
  user.uid = user.phoneNumber.toString().substring(3);

  print("Uid:${user.uid}");
  //await prefs.setString('id', firebaseUser.uid);
  //user.uid = firebaseUser.uid;
  ref.doc(user.uid).set(user.toMap()).then((value) => value = true);
}

//Searching the Users-------------------------------------
searchResultsListForUser(authNotifier) {
  List<CreateUserModel> showResults = [];

  if (searchControllerForUserlist.text != "") {
    snapshotForUser.docs.forEach((document) {
      var title =
          CreateUserModel.fromMap(document.data()).displayName.toLowerCase();
      if (title.contains(searchControllerForUserlist.text.toLowerCase())) {
        CreateUserModel userModel = CreateUserModel.fromMap(document.data());
        // print(searchControllerForUserlist);
        showResults.add(userModel);
        print('in if');
        print(showResults.length);
      }
    });
  } else {
    snapshotForUser.docs.forEach((document) {
      CreateUserModel userModel = CreateUserModel.fromMap(document.data());
      print('in else');

      showResults.add(userModel);
    });
  }
  return authNotifier.userListt = showResults;
}

getUserStreamSnapshots(authNotifier) async {
 userGot = false;
  await FirebaseFirestore.instance
      .collection('users')
      .orderBy('firstChar')
      .get()
      .then((value) {
    snapshotForUser = value;
    print(value.docs.length);
    userGot = true;
  });
  searchResultsListForUser(authNotifier);
  return "complete";
}
