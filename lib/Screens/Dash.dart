import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:pandamart/provider/navigator_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/Order.dart';
import '../model/Vehicle.dart';
import '../styleguide/text_style.dart';
import '../widget/navigation_drawer_widget.dart';
import 'order.dart';

class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  State<Home2> createState() => _HomeState();
}

class _HomeState extends State<Home2> with SingleTickerProviderStateMixin {
  late Map<String, dynamic> jsonResponse;
  late Map<String, double> dataMap;
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  bool showProgress = true;
  List<Order> _foundUsers = [];
  late Future<List<Order>> futureAlbum;
  String number = "";
  List<String> buttonTexts = [];
  late List<Order> items1;
  TextEditingController cancel_controller = new TextEditingController();
  TextEditingController collect_controller = new TextEditingController();
  bool status = false;
  String? _currentAddress;
  Position? _currentPosition;
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  static final List<String> chartDropdownItems = [
    'Last 7 days',
    'Last month',
    'Last year'
  ];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;
  // late TabController _tcontrol;
  @override
  void initState() {
    _getCurrentPosition();
    futureAlbum = fetchData();
  }

  Future<List<Order>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = await prefs.getString("userId");
    var vehi_id = await prefs.getString("vehi_id");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final response = await http.get(Uri.parse(
        'http://151.106.17.246:8080/hascol/api/get_all_orders.php?accesskey=12345&user_id=${user_id}'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(response.body);
      items1 = jsonResponse.map((data) => new Order.fromJson(data)).toList();

      setState(() {
        _foundUsers = items1;

        showProgress = false;
      });
      return jsonResponse.map((data) => new Order.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: MaterialApp(
        title: "Home",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading:  GestureDetector(
              child: Icon( Icons.arrow_back_ios, color: Colors.white,  ),
              onTap: () {
                Navigator.pop(context);
              } ,
            ) ,
            backgroundColor: const Color(0xff2b3993),
            title: const Text("Orders"),
          ),

          body: RefreshIndicator(
            displacement: 250,
            backgroundColor: Color(0xff2b3993),
            color: Color(0xff2b3993),
            strokeWidth: 3,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            onRefresh: () async {
              fetchData();
            },
            child: Stack(
              children: [
                Container(
                  child: FutureBuilder<List<Order>>(
                      future: futureAlbum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: _foundUsers
                                .length, // set the number of items in the list
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: const Color(0xffffffff),
                                elevation: 10,

                                shape:
                                  Border(left: BorderSide(color: Colors.red, width: 3)),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),

                                child: GestureDetector(

                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xffffffff),
                                          Color(0xffbdbbbb),
                                          Color(0xffffffff),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            "Depot: " +
                                                _foundUsers[index].depot,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Color(0xff2b3993),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    "Quantity:",
                                                    style:
                                                        whiteSubHeadingTextStyle
                                                            .copyWith(
                                                                color:
                                                                    Color(0xff2b3993),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    _foundUsers[index].quantity,
                                                    style:
                                                        whiteSubHeadingTextStyle
                                                            .copyWith(
                                                                color:
                                                                    Color(0xff2b3993),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    "Order Time:",
                                                    style:
                                                        whiteSubHeadingTextStyle
                                                            .copyWith(
                                                                color:
                                                                    Color(0xff2b3993),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    new DateFormat(
                                                            'yyyy-MM-dd hh:mm a')
                                                        .format(_foundUsers[index]
                                                            .time)
                                                        .toString(),
                                                    style:
                                                        whiteSubHeadingTextStyle
                                                            .copyWith(
                                                                color:
                                                                    Color(0xff2b3993),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          // leading: ClipOval(
                                          //   child: Icon(Icons.near_me,
                                          //     color: true ? Colors.green : Colors.red
                                          //     ,size: 30,),
                                          // ),

                                        ),
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Icon(
                                              Icons.location_on,
                                              color:Color(0xff2b3993),
                                              size: 13,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Flexible(
                                              child: Text(
                                                  _foundUsers[index].delivery_based,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    color:Color(0xff2b3993),
                                                    fontWeight: FontWeight.w800,
                                                  )),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Icon(
                                              Icons.payment,
                                              color:Color(0xff2b3993),
                                              size: 13,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Flexible(
                                              child: Text(
                                                  "Rs. "+_foundUsers[index].amount,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    color: Color(0xff2b3993),
                                                    fontWeight: FontWeight.w800,
                                                  )),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 20,
                                            ),


                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default show a loading spinner.
                        return Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Color(0xFFB4B4B4),
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Color(0xFF7A0813)),
                        ));
                      }),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Create_Order(),
              ));
            },
            child: FaIcon(FontAwesomeIcons.opencart,color: Colors.black,),
          ),
        ),
      ),
    );
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    // if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    // } else {
    //   throw 'Could not open the map.';
    // }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}
