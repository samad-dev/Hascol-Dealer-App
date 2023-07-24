import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pandamart/Screens/Dash.dart';

class SignInTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.pink
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
                Image.asset(
                  'Assets/foodpanda_logo.png',
                  color: Colors.white,
                ),
                SizedBox(
                  height: 50,
                ),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 45,color: Colors.pink),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                              decoration: InputDecoration(
                                  focusColor: Colors.pink,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.pink)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.pink)),
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Colors.pink)),
                            ),
                          ),
                          TextFormField(
                            obscureText: true,
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                            decoration: InputDecoration(
                                focusColor: Colors.pink,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.pink)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.pink)),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    fontSize: 15, color: Colors.pink)),
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
                                Navigator.pushReplacement<void, void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const Home2(),
                                  ),
                                );
                              },
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFUIDisplay',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              color: Color(0xffff2d55),
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
}
