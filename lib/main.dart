import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pandamart/Screens/Dash.dart';
import 'package:pandamart/Screens/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foodpanda',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getValue();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Image.asset('Assets/foodpanda_logo.png'),
      ),
    );
  }
  void getValue() async {
    var prefs = await SharedPreferences.getInstance();
    var getName = (prefs.getString("userId") ?? "");
    // nameValue = getName != null ? getName : "No Value Saved ";
    if (getName == "") {
      Timer(Duration(seconds: 3), () {

        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                Home(),
          ),
        );
      });
    } else {
      Timer(Duration(seconds: 3), () {

        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                MyHomePage(),
          ),
        );
      });

    }
    setState(() {

    });
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Foodpanda'),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home2()),
                );
                // TODO: Go to the home screen.
              },
            ),
          ],
        ),
      ),
    );
  }
}
/*
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'Home.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );

  }

}*/
