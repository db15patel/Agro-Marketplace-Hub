import 'package:agrocart/AppScreens/admin/products/dialouge.dart';
import 'package:agrocart/backend/api/user_api.dart';
import 'package:agrocart/backend/notifier/auth_notofier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScaffold extends StatefulWidget {
  final String title;
  final Widget body;

  const AddScaffold({
    Key key,
    @required this.body,
    @required this.title,
  }) : super(key: key);

  @override
  _AddScaffoldState createState() => _AddScaffoldState();
}

class _AddScaffoldState extends State<AddScaffold> {
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      color: Colors.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
              title: Text(
                widget.title,
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: false,
              actions: [
                authNotifier.userId != null
                    ? IconButton(
                        color: Colors.black,
                        onPressed: () async {
                          final action = await Dialogs.yesAbortDialog(context,
                              'Confirm', 'Are you sure want to Logout?');
                          if (action == DialogAction.yes) {
                            signout(authNotifier);
                          } else {}
                        },
                        icon: Icon(Icons.power_settings_new),
                      )
                    : Container(),
              ]),
          body: widget.body,
        ),
      ),
    );
  }
}
