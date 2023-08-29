import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  GoogleMapController? _controller;
  double lat = 30.3753, lng = 69.3451;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  final MarkerId markerId = MarkerId('1');
  List<Marker> marker = [];
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  int total_orders =0;
  int    online_payment=0;
  int    cash_orders=0;
  int    credit_card=0;
  int    ontrip_orders=0;
  int    complete_orders=0;
  int    pending_orders=0;
  int    cancel_orders = 0;
  int    total_amount = 0;
  String    recieved_amount = "0";
  List<Marker> markers = [];


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
                      color: Color(0xff2b3993),
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
  int _selectedIndex = 0;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            backgroundColor: const Color(0xff2b3993),
            title: Text('Dashboard'),
          ),
          /*bottomNavigationBar: BottomNavigationBar(
              showUnselectedLabels: false,
              backgroundColor: Color(0xffffffff),

              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.dashboard,color: Colors.amber,),
                    label: 'Dashboard',


                ),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.firstOrderAlt,color: Colors.amber,),
                    label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              type: BottomNavigationBarType.shifting,
              currentIndex: _selectedIndex,
              selectedItemColor: Color(0xff2b3993),
              selectedIconTheme: IconThemeData(color: Color(0xff2b3993)),
              iconSize: 20,
              onTap: _onItemTapped,
              elevation: 5
          ),*/
          drawer: Nav(),
          body:Container(
            color:Color(0xffE5E5E5),
            child:StaggeredGridView.count(
              crossAxisCount: 6,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              staggeredTiles: [
                StaggeredTile.extent(6,110.0),
                StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(2, 120.0),
                StaggeredTile.extent(6, 120.0),
                StaggeredTile.extent(3, 120.0),
                StaggeredTile.extent(3, 120.0),
                StaggeredTile.extent(6, 260.0),
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
                                     style: TextStyle(color: Color(0xff2b3993),fontSize: 16,fontWeight: FontWeight.w700)),
                                Text(total_orders.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0))
                              ],
                            ),
                            Material(
                                color: Color(0xff2b3993),
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
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Completed\n Orders',
                                  style: TextStyle(color: Color(0xff2b3993),fontSize: 12,fontWeight: FontWeight.w700)),
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
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('InProcess\n Orders',
                                  style: TextStyle(color: Color(0xff2b3993),fontSize: 12,fontWeight: FontWeight.w700)),
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
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Pending\n Orders',
                                  style: TextStyle(color: Color(0xff2b3993),fontSize: 12,fontWeight: FontWeight.w700)),
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
                              const Text('Total Complaints',
                                   style: TextStyle(color: Color(0xff2b3993),fontSize: 16,fontWeight: FontWeight.w700)),
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
                              const Text('Open Complaints',
                                   style: TextStyle(color: Color(0xff2b3993),fontSize: 14,fontWeight: FontWeight.w700)),
                              Text(cash_orders.toString(),
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
                              const Text('Closed Complaints',
                                   style: TextStyle(color: Color(0xff2b3993),fontSize: 14,fontWeight: FontWeight.w700)),
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
                _buildTile(

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GoogleMap(
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      mapType: MapType.normal,
                      markers:Set<Marker>.of(marker),
                      initialCameraPosition: CameraPosition(
                        target: LatLng(lat, lng),
                        zoom: 13.4746,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller =controller;
                      },
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api();
    // api2();
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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userId = await sharedPreferences.getString("userId");
    var cords = await sharedPreferences.getString("latlng");
    print("SOMI"+cords.toString());
    List<String> result = cords!.split(',');
    print("LAT"+result[0]+"LNG:"+result[1]);
    setState(() {

      marker.add(Marker(
        markerId: MarkerId('1'),
        position: LatLng(
          lat,
          lng,
        ),
      ));
      lat = double.parse(result[0]);
      lng = double.parse(result[1]);
      _controller?.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(lat,lng), zoom: 17)
            //17 is new zoom level
          )
      );
    });

    var request = http.Request('GET', Uri.parse('http://151.106.17.246:8080/hascol/api/dashboard_counts.php?accesskey=12345&user_id=${userId}'));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print( response.stream.bytesToString());
      var json = await response.stream.bytesToString();
      print(json);
      List jsons = jsonDecode(json);
      print("Samad"+jsons[0]['id'].toString());
      if(jsons[0] != null)
      {
        print(jsons[0]["total_orders"].toString());
        setState(() {
          total_orders = int.parse(jsons[0]["order_detail"].toString());
          online_payment = int.parse(jsons[0]["complaints"].toString());
          cash_orders = int.parse(jsons[0]["complaints_pending"].toString());
          ontrip_orders = int.parse(jsons[0]["order_ontrip"].toString());
          credit_card = int.parse(jsons[0]["complaints"].toString());
          complete_orders = int.parse(jsons[0]["order_complete"].toString());
          // complete_orders = int.parse(jsons[0]["order_complete"].toString());
          pending_orders = int.parse(jsons[0]["order_pending"].toString());
          recieved_amount = jsons[0]["complaints_complete"];

          // cancel_orders = int.parse(jsons[0]["cancel_orders"].toString());

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
