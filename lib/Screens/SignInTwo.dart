import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pandamart/Screens/Dash.dart';
import 'package:http/http.dart' as http;
import 'package:pandamart/Screens/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NewMain.dart';

class SignInTwo extends StatelessWidget {
  TextEditingController emailcont = new TextEditingController();
  TextEditingController passcont = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xff5982ef)
          /*image: DecorationImage(
          image: AssetImage('Assets/image2.png'),
          fit: BoxFit.cover,
        )*/
          ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.all(23),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset(
                    'Assets/haslogo.png',
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Card(
                  shape: Border(right: BorderSide(color: Colors.red, width: 5)),
                  elevation: 10,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 45,color: Color(0xff06298a)),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: TextFormField(
                              controller: emailcont,
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                              decoration: InputDecoration(
                                  focusColor: Color(0xff06298a),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff06298a))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xff06298a))),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Color(0xff06298a))),
                            ),
                          ),
                          TextFormField(
                            controller: passcont,
                            obscureText: true,
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                            decoration: InputDecoration(
                                focusColor: Color(0xff06298a),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Color(0xff06298a))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Color(0xff06298a))),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    fontSize: 15, color: Color(0xff06298a))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 5),
                            child: Text(
                              'Forgot your password?',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontFamily: 'SFUIDisplay',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: MaterialButton(
                              onPressed: () {
                                api(emailcont.text.toString(),passcont.text.toString(),context);

                              },
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFUIDisplay',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              color: Color(0xffF15A29),
                              elevation: 0,
                              minWidth: 350,
                              height: 60,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> api(String email, String password,BuildContext context) async {

    print('http://151.106.17.246:8080/hascol/api/dealer_login.php?accesskey=12345&email=${emailcont.text.toString()}&pass=${passcont.text.toString()}');
    var request = http.Request('GET', Uri.parse('http://151.106.17.246:8080/hascol/api/dealer_login.php?accesskey=12345&email=${emailcont.text.toString()}&pass=${passcont.text.toString()}'));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print( response.stream.bytesToString());
      var json = await response.stream.bytesToString();
      print(json);
      List jsons = jsonDecode(json);
      print("Samad"+jsons.length.toString());
      if(jsons[0] != null)
      {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("userId", jsons[0]["id"].toString());
        await prefs.setString("user_name", jsons[0]["name"].toString());
        await prefs.setString("vehi_id", jsons[0]["housekeeping"].toString());
        await prefs.setString("latlng", jsons[0]["co-ordinates"].toString());
        await prefs.setString("email", email.toString());
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                MyHomePage(),
          ),
        );

      }
      else
      {
        const snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Invalid Username or Password'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }
  void getValue(context) async {
    var prefs = await SharedPreferences.getInstance();
    var getName = (prefs.getString("userId") ?? "");
    // nameValue = getName != null ? getName : "No Value Saved ";
    if (getName == "") {

    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Home2()
          ),
          ModalRoute.withName("/Home")
      );

    }

  }
}
