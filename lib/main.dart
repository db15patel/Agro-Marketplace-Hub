import 'package:agrocart/AppScreens/initialPages/homePage.dart';
import 'package:agrocart/AppScreens/initialPages/login.dart';
import 'package:agrocart/backend/api/user_api.dart';
import 'package:agrocart/backend/notifier/auth_notofier.dart';
import 'package:agrocart/backend/notifier/product_notifier.dart';
import 'package:agrocart/utils/agrocart.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  //print("The statement 'this machine is connected to the Internet' is: ");
  //print(await DataConnectionChecker().hasConnection);
  await DataConnectionChecker().connectionStatus;

  //print("Current status: ${await DataConnectionChecker().connectionStatus}");

  // print("Last results: ${DataConnectionChecker().lastTryResults}");
  var listener = DataConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case DataConnectionStatus.connected:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ));
        print('Data connection is available.');
        runApp(MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => AuthNotifier(),
            ),
            ChangeNotifierProvider(
              create: (BuildContext context) {
                return BookNotifier();
              },
            )
          ],
          child: AgroCart(),
        ));
        break;
      case DataConnectionStatus.disconnected:
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ));
        print('You are disconnected from the internet.');
        runApp(
          SomethingWentWrong(),
        );
        break;
    }
  });

  await Future.delayed(Duration(seconds: 30));
  await listener.cancel();
}

class AgroCart extends StatefulWidget {
  @override
  _AgroCartState createState() => _AgroCartState();
}

class _AgroCartState extends State<AgroCart> {
  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AgrocartUniversal.google_sans_family,
        primarySwatch: Colors.lightGreen,
        primaryColor: Colors.white,
        disabledColor: Colors.grey,
        cardColor: Colors.white,
        canvasColor: Colors.grey[50],
        brightness: Brightness.light,
        buttonTheme: Theme.of(context)
            .buttonTheme
            .copyWith(colorScheme: ColorScheme.light()),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
        ),
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
      //    initializeCurrentUser(notifier);
          return 
          //waitingHomeScreen == false ? Scaffold(body: Center(child: CircularProgressIndicator(),)) :
           notifier.user != null
              ? HomeScreen(currentuser: notifier.userId)
              : Login();
        },
      ),
    );
  }
}

class SomethingWentWrong extends StatefulWidget {
  @override
  _SomethingWentWrongState createState() => _SomethingWentWrongState();
}

class _SomethingWentWrongState extends State<SomethingWentWrong> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            appBarTheme: AppBarTheme(
              brightness: Brightness.light,
              elevation: 5,
              color: ThemeData.light().canvasColor,
            )),
        home: Scaffold(
          body: Container(
              color: AgrocartUniversal.contrastColor,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AgrocartUniversal.intenetError),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      AgrocartUniversal.noInternet,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ));
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //primarySwatch: AgrocartUniversal.contrastColor,
          primaryColor: Colors.white,
          disabledColor: Colors.grey,
          cardColor: Colors.white,
          canvasColor: Colors.grey[50],
          brightness: Brightness.light,
          buttonTheme: Theme.of(context)
              .buttonTheme
              .copyWith(colorScheme: ColorScheme.light()),
          appBarTheme: AppBarTheme(
            elevation: 0.0,
          ),
        ),
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
