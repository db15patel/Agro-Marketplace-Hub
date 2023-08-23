import 'package:flutter/material.dart';

class AgrocartUniversal {
  static const String app_name = "agrocart";
  static const String app_version = "Version 1.0.0";
  static const int app_version_code = 1;
  static const String app_color = "#ffd7167";
  static Color primaryAppColor = Colors.white;
  static Color secondaryAppColor = Colors.black;
  static const String google_sans_family = "GoogleSans";
  static bool isDebugMode = false;
  static Color contrastColor = Color(0xff8EE80E);
  static Color contrastColorLight = Color(0xffcff597);
  static List<String> adminList = [];

  static const String banner = "assets/banner.png";
  static const String intenetError = "assets/croods.png";

  static const String whatIsGoodWill = "What is AgroCart?";
  static const String aboutusText =
      "AgroCart is an E-commerce application based on Agriculture. It is created for the shop Shree hare Agriculture. Farmers can buy all types of agricultural things from here";
      static const String noInternet =
      "No Internet!! Turn on the Internet and open again \n\n (After turning on, you can wait for 5 sec to get in the app automatically)";


  static const String supportString =
      "If you have any question or problem, you can contact us here";

  static const String address =
      'Solapura crossing, ajarpura, anand, gujarat 388310 India';

  static List<BoxShadow> customBoxShadow = [
    BoxShadow(
        color: Colors.black.withOpacity(0.075),
        blurRadius: 7,
        offset: Offset(
          7,
          7,
        )),
    BoxShadow(
        color: Colors.black.withOpacity(0.015),
        blurRadius: 7,
        offset: Offset(
          -7,
          -7,
        )),
  ];
}

class ButtonClass extends StatelessWidget {
  final String name;
  final Function func;

  const ButtonClass({Key key, this.name, this.func}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('In Current profile card');
    print(name);
    return InkWell(
      //splashColor: Color(0xffffb3b3),
      borderRadius: BorderRadius.circular(8),
      hoverColor: AgrocartUniversal.contrastColor,
      onTap: func,
      child: Ink(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Color(0xfff8bc05))
            boxShadow: AgrocartUniversal.customBoxShadow),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AgrocartUniversal.contrastColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
