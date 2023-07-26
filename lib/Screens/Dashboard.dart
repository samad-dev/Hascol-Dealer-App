import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../provider/navigator_provider.dart';
import '../widget/navigation_drawer_widget.dart';
import 'Dash.dart';

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>  with SingleTickerProviderStateMixin{
  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  var data1 = [0.0,-2.0,3.5,-2.0,0.5,0.7,0.8,1.0,2.0,3.0,3.2];
  int total_orders =0;
  int    online_payment=0;
  int    cash_orders=0;
  int    credit_card=0;
  int    ontrip_orders=0;
  int    complete_orders=0;
  int    pending_orders=0;
  int    cancel_orders = 0;
  double    total_amount = 0.0;
  String    recieved_amount = "0";


  Material myTextItems(String title, String subtitle){
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(title,style:TextStyle(
                      fontSize: 20.0,
                      color: Colors.pinkAccent,
                    ),),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text(subtitle,style:TextStyle(
                      fontSize: 30.0,
                    ),),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }








  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: MaterialApp(
        title: "Home",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xffff2d55),
            title: Text('Dashboard'),

          ),
          drawer: Nav(),
          body:Container(
            color:Color(0xffE5E5E5),
            child:StaggeredGridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              staggeredTiles: [
                StaggeredTile.extent(4,110.0),
                StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(4, 110.0),
                StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(2, 120.0),
              ],
              children: <Widget>[
                _buildTile(
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home2()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Total Orders',
                                    style: TextStyle(color: Colors.pinkAccent)),
                                Text(total_orders.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0))
                              ],
                            ),
                            Material(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(24.0),
                                child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(Icons.shopping_cart,
                                          color: Colors.white, size: 30.0),
                                    )))
                          ]),
                    ),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('On Trip Orders',
                                  style: TextStyle(color: Colors.pinkAccent)),
                              Text(ontrip_orders.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0))
                            ],
                          ),

                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Pending Orders',
                                  style: TextStyle(color: Colors.pinkAccent)),
                              Text(pending_orders.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0))
                            ],
                          ),

                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Completed Orders',
                                  style: TextStyle(color: Colors.pinkAccent)),
                              Text(complete_orders.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0))
                            ],
                          ),

                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Cancelled Orders',
                                  style: TextStyle(color: Colors.pinkAccent)),
                              Text(cancel_orders.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0))
                            ],
                          ),

                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Online Payment',
                                  style: TextStyle(color: Colors.pinkAccent)),
                              Text(online_payment.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0))
                            ],
                          ),
                          Material(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(24.0),
                              child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Icon(Icons.payment,
                                        color: Colors.white, size: 30.0),
                                  )))
                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Cash Payment',
                                  style: TextStyle(color: Colors.pinkAccent)),
                              Text(cash_orders.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0))
                            ],
                          ),

                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Card Payments',
                                  style: TextStyle(color: Colors.pinkAccent)),
                              Text(credit_card.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0))
                            ],
                          ),

                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Total Amount',
                                  style: TextStyle(color: Colors.pinkAccent)),
                              Text(total_amount.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30.0))
                            ],
                          ),


                        ]),
                  ),
                ),
                _buildTile(
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Recieved Amount',
                                  style: TextStyle(color: Colors.pinkAccent)),
                              Text(recieved_amount.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0))
                            ],
                          ),

                        ]),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api();
    api2();
  }

  Widget _buildTile(Widget child, {Function()? onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
              print('Not set yet');
            },
            child: child));
  }

  Future<void> api() async {
    var request = http.Request('GET', Uri.parse('http://151.106.17.246:8080/pandamart_close/api/app_dashboard.php?accesskey=12345'));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print( response.stream.bytesToString());
      var json = await response.stream.bytesToString();
      List jsons = jsonDecode(json);
      print("Samad"+jsons[0]['id'].toString());
      if(jsons[0] != null)
      {
        print(jsons[0]["total_orders"].toString());
        setState(() {
          total_orders = int.parse(jsons[0]["total_orders"].toString());
          online_payment = int.parse(jsons[0]["online_payment"].toString());
          cash_orders = int.parse(jsons[0]["cash_orders"].toString());
          ontrip_orders = int.parse(jsons[0]["ontrip_orders"].toString());
          complete_orders = int.parse(jsons[0]["complete_orders"].toString());
          complete_orders = int.parse(jsons[0]["complete_orders"].toString());
          pending_orders = int.parse(jsons[0]["pending_orders"].toString());
          cancel_orders = int.parse(jsons[0]["cancel_orders"].toString());

        });



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

  Future<void> api2() async {
    var request = http.Request('GET', Uri.parse('http://151.106.17.246:8080/pandamart_close/api/app_dashboard_amount.php?accesskey=12345'));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print( response.stream.bytesToString());
      var json = await response.stream.bytesToString();
      List jsons = jsonDecode(json);
      print("Samad"+jsons[0]['id'].toString());
      if(jsons[0] != null)
      {
        print(jsons[0]["total_amount"].toString());
        setState(() {
            total_amount = double.parse(jsons[0]["total_amount"].toString());
            recieved_amount = jsons[0]["receive_amount"].toString();

        });



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
}
