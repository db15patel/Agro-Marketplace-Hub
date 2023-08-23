import 'package:agrocart/backend/api/user_api.dart';
import 'package:agrocart/backend/models/user_model.dart';
import 'package:agrocart/backend/notifier/auth_notofier.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:agrocart/utils/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }
bool waitingHomeScreen = false;
AuthMode authMode = AuthMode.Login;
bool progressLogin = false;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String phoneNo, verificationId, smsCode;
  //CreateUserModel userDetail = CreateUserModel();
  UserModel userr = UserModel();
  bool codeSent = false;

  //bool progress = false;
  Future<bool> _onUserNotExist() async {
    setState(() {
      progressLogin = false;
    });
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: authMode == AuthMode.Login
                ? Text('Not have an Account?')
                : Text('Have an Account?'),
            content: authMode == AuthMode.Login
                ? Text('Do you not have any account? SignUp to have one!')
                : Text(
                    'Do you have an account already? Login with Login Page!'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('ok'),
              ),

              // new FlatButton(
              //   onPressed: () => Navigator.of(context).pop(false),
              //   child: new Text('Signup now'),
              // ),
            ],
          ),
        )) ??
        false;
  }

  void _submitForm() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      progressLogin = true;
    });
    if (authMode == AuthMode.Login) {
      FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNo)
          .get()
          .then((value) {
        if (value.docs.length == 1) {
          print('User Exist');
          codeSent
              ? signInWithOTP(smsCode, verificationId, userr, authNotifier)
              : verifyPhone(phoneNo);
        } else {
          _onUserNotExist();
        }
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNo)
          .get()
          .then((value) {
        if (value.docs.length == 1) {
          print('User Exist');
          _onUserNotExist();
        } else {
          codeSent
              ? signInWithOTP(smsCode, verificationId, userr, authNotifier)
              : verifyPhone(phoneNo);
        }
      });
    }
  }

  Widget _buildPhoneField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Phone Number",
        labelStyle: TextStyle(color: Colors.grey, fontSize: 15),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabledBorder: new UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      keyboardType: TextInputType.phone,
      style: TextStyle(fontSize: 19, color: Colors.black),
      cursorColor: AgrocartUniversal.contrastColor,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Phone Number is required';
        }
        if (value.length < 0 || value.length > 10) {
          return 'Phone no must be 10 digit';
        }
        return null;
      },
      onSaved: (String value) {
        this.phoneNo = '+91' + value;
        userr.phoneNumber = '+91' + value;
      },
    );
  }

  Widget _displayNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Display Name",
        labelStyle: TextStyle(color: Colors.grey),
      ),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 19, color: Colors.black),
      cursorColor: AgrocartUniversal.contrastColor,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Display Name is required';
        }

        if (value.length < 5 || value.length > 12) {
          return 'Display Name must be betweem 5 and 12 characters';
        }

        return null;
      },
      onSaved: (String value) {
        userr.displayName = value;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Address",
        labelStyle: TextStyle(color: Colors.grey),
      ),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 19, color: Colors.black),
      cursorColor: AgrocartUniversal.contrastColor,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Address is required';
        }
        return null;
      },
      onSaved: (String value) {
        userr.address = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building Login screen");
    return Scaffold(
        body: Container(
      child: Form(
        autovalidate: true,
        key: _formKey,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 76, 30, 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: authMode == AuthMode.Signup
                                ? Text('SignUp',
                                    style: TextStyle(
                                        fontSize: 65.0,
                                        fontWeight: FontWeight.bold))
                                : Text('Login',
                                    style: TextStyle(
                                        fontSize: 65.0,
                                        fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            child: Text('.',
                                style: TextStyle(
                                    fontSize: 65.0,
                                    fontWeight: FontWeight.bold,
                                    color: AgrocartUniversal.contrastColor)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    codeSent
                        ? Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: "Enter the OTP",
                                  labelStyle: TextStyle(color: Colors.grey),
                                  enabledBorder: new UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: new UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                style: TextStyle(fontSize: 17, color: Colors.black),
                                onChanged: (val) {
                                  setState(() {
                                    this.smsCode = val;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 25,
                                child: Text(
                                  'OTP send to ${userr.phoneNumber} number',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    authMode == AuthMode.Signup && !codeSent
                        ? _displayNameField()
                        : Container(),
                    authMode == AuthMode.Signup && !codeSent
                        ? _buildAddressField()
                        : Container(),
                    !codeSent ? _buildPhoneField() : Container(),
                    SizedBox(height: 25),
                    InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () => _submitForm(),
                      child: Ink(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.88,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: AgrocartUniversal.customBoxShadow,
                            color: AgrocartUniversal.contrastColor,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              authMode == AuthMode.Login ? 'Login' : 'SignUp',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          )),
                    ),
                    SizedBox(height: 16),
                    ButtonTheme(
                      minWidth: 200,
                      child: FlatButton(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Switch to ${authMode == AuthMode.Login ? 'Signup' : 'Login'}',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        onPressed: () {
                          setState(() {
                            authMode = authMode == AuthMode.Login
                                ? AuthMode.Signup
                                : AuthMode.Login;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

              progressLogin == true
                    ? Positioned(child: Center(child: Loading()))
                    : Container(),
          ],
        ),
      ),
    ));
  }

  Future<void> verifyPhone(phoneNo) async {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    final PhoneVerificationCompleted verified =
        (PhoneAuthCredential credential) {
      signIn(credential, userr, authNotifier);
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }

      // Handle other errors
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
        progressLogin = false;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
