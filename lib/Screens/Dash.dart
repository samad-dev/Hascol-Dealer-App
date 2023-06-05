import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pandamart/provider/navigator_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/Order.dart';
import '../model/Vehicle.dart';
import '../styleguide/text_style.dart';
import '../widget/navigation_drawer_widget.dart';
class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  State<Home2> createState() => _HomeState();
}

class _HomeState extends State<Home2> with SingleTickerProviderStateMixin {
  late Map<String,dynamic> jsonResponse;
  late Map<String, double> dataMap;
  bool showProgress = true;
  List<Order> _foundUsers = [];
  late Future<List<Order>> futureAlbum;
  String number="";
  late List<Order> items1;

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
    futureAlbum = fetchData();
  }
  Future<List<Order>> fetchData() async {
    final response = await http.get(Uri.parse('http://151.106.17.246:8080/pandamart_close/api/mart_disparched_orders.php?accesskey=12345&user_id=3'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(response.body);
      items1 = jsonResponse.map((data) => new Order.fromJson(data)).toList();

      setState(() {
        _foundUsers = items1;
        number = items1.length.toString();
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
            backgroundColor: const Color(0xffff2d55),
            title: const Text("Dashboard"),
          ),
          drawer: Nav(),
          body: RefreshIndicator(
            displacement: 250,
            backgroundColor: Colors.white,
            color: Color(0xffff2d55),
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
                        if(snapshot.hasData)
                        {
                          return ListView.builder(
                            itemCount: _foundUsers.length, // set the number of items in the list
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: (){
                                  showGeneralDialog(
                                      barrierColor:
                                      Colors.black.withOpacity(0.5),
                                      transitionBuilder:
                                          (context, a1, a2, widget) {
                                        return Transform.scale(
                                          scale: a1.value,
                                          child: Opacity(
                                              opacity: a1.value,
                                              child: AlertDialog(
                                                title: Text(
                                                  "Please Confirm",
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    fontSize:12,
                                                  ),
                                                ),
                                                actionsAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                content: Text(
                                                  "Are you sure you want to Start Delivery?",
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    fontSize: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .width *
                                                        0.03,
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                          MaterialStateProperty.all(
                                                              Colors
                                                                  .red)),
                                                      onPressed: () {
                                                        openMap(-3.823216,-38.481700);
                                                        print('samad');
                                                      },
                                                      child: Text(
                                                        "Yes",
                                                        style:
                                                        TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontFamily:
                                                          'Nunito',
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          fontSize: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.03,
                                                        ),
                                                      )),
                                                  TextButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                          MaterialStateProperty.all(
                                                              Colors
                                                                  .grey)),
                                                      onPressed: () =>
                                                          Navigator.of(
                                                              context)
                                                              .pop(
                                                              false),
                                                      child: Text(
                                                        "No",
                                                        style:
                                                        TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontFamily:
                                                          'Nunito',
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          fontSize: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.03,
                                                        ),
                                                      )),
                                                ],
                                              )),
                                        );
                                      },
                                      transitionDuration:
                                      const Duration(
                                          milliseconds: 200),
                                      barrierDismissible: false,
                                      barrierLabel: '',
                                      context: context,
                                      pageBuilder: (context, animation1,
                                          animation2) {
                                        return const Text(
                                            'PAGE BUILDER');
                                      });
                                },
                                child: Card(
                                  color: const Color(0xffff2d55),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          _foundUsers[index].customer_name,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text("Payment Method:",
                                                  style: whiteSubHeadingTextStyle.copyWith(color: Colors.white, fontSize: 12,fontWeight: FontWeight.w700),
                                                ),
                                                SizedBox(width: 4,),
                                                Text(_foundUsers[index].power,
                                                  style: whiteSubHeadingTextStyle.copyWith(color: Colors.white, fontSize: 12,fontWeight: FontWeight.w700),
                                                ),

                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text("Order Time:",
                                                  style: whiteSubHeadingTextStyle.copyWith(color: Colors.white, fontSize: 12,fontWeight: FontWeight.w700),
                                                ),
                                                SizedBox(width: 4,),
                                                Text(new DateFormat('yyyy-MM-dd hh:mm a').format(_foundUsers[index].time).toString(),
                                                  style: whiteSubHeadingTextStyle.copyWith(color: Colors.white, fontSize: 12,fontWeight: FontWeight.w700),
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
                                        trailing: SizedBox(
                                          width:55,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Expanded(

                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.payment,
                                                          color: Colors.white,
                                                        ),


                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "Rs.${_foundUsers[index].order_amount}",
                                                          style: whiteSubHeadingTextStyle.copyWith(color: Color(0xffffffff), fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(width: 20,),
                                          Icon(Icons.location_on,
                                            color: Color(0xffffffff),size: 13,),
                                          SizedBox(width: 4,),
                                          Flexible(
                                            child: Text(
                                                _foundUsers[index].vlocation,
                                                overflow: TextOverflow.ellipsis,
                                                style:TextStyle(
                                                  fontSize: 10.0,
                                                  color: Color(0xffffffff),
                                                  fontWeight: FontWeight.w800,
                                                )
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(width: 20,),
                                          Icon(Icons.visibility,
                                            color: Colors.white,size: 13,),
                                          SizedBox(width: 4,),
                                          Flexible(
                                            child: Text(
                                                  "${_foundUsers[index].written_address}",

                                                overflow: TextOverflow.ellipsis,
                                                style:TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                )
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default show a loading spinner.
                        return Center(child: CircularProgressIndicator(backgroundColor: Color(0xFFB4B4B4),valueColor:new AlwaysStoppedAnimation<Color>(Color(
                            0xFF7A0813)),));
                      }
                  ),
                ),
              ],
            ),
          ),
          /*body: SingleChildScrollView(
                child: FutureBuilder<List<Order>>(
                    future: futureAlbum,
                    builder: (context, snapshot) {
                      if(snapshot.hasData)
                      {
                        return ListView.builder(
                          itemCount: _foundUsers.length, // set the number of items in the list
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: (){
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => MapSample(_foundUsers[index].id,_foundUsers[index].name,_foundUsers[index].latitude,_foundUsers[index].longitude,_foundUsers[index].vlocation,_foundUsers[index].time.toString(),_foundUsers[index].speed,_foundUsers[index].power,_foundUsers[index].vehicle_make)),
                                // );
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        _foundUsers[index].customer_name,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Color(0xff7a0813),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle:
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text("Ignition:",
                                                style: whiteSubHeadingTextStyle.copyWith(color: Color(
                                                    0xfff34c59), fontSize: 12,fontWeight: FontWeight.w700),
                                              ),
                                              SizedBox(width: 4,),
                                              Text(int.parse(_foundUsers[index].power)>0 ? "ON" : "OFF",
                                                style: whiteSubHeadingTextStyle.copyWith(color: Color(0xfff34c59), fontSize: 12,fontWeight: FontWeight.w700),
                                              ),

                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text("Last Update:",
                                                style: whiteSubHeadingTextStyle.copyWith(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w700),
                                              ),
                                              SizedBox(width: 4,),
                                              Text(new DateFormat('yyyy-MM-dd hh:mm a').format(_foundUsers[index].time).toString(),
                                                style: whiteSubHeadingTextStyle.copyWith(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w700),
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
                                      trailing: SizedBox(
                                        width:55,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Expanded(

                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.speed,
                                                        color: int.parse(_foundUsers[index].speed) > 55 ? Colors.red : Colors.green,
                                                      ),


                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "${_foundUsers[index].speed} Km/H",
                                                        style: whiteSubHeadingTextStyle.copyWith(color: Color(0xff003b46), fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        SizedBox(width: 20,),
                                        Icon(Icons.location_on,
                                          color: Color(0xff003b46),size: 13,),
                                        SizedBox(width: 4,),
                                        Flexible(
                                          child: Text(
                                              _foundUsers[index].vlocation,
                                              overflow: TextOverflow.ellipsis,
                                              style:TextStyle(
                                                fontSize: 10.0,
                                                color: Color(0xff003b46),
                                                fontWeight: FontWeight.w800,
                                              )
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: <Widget>[
                                        SizedBox(width: 20,),
                                        Icon(Icons.visibility,
                                          color: Color(0xff003b46),size: 13,),
                                        SizedBox(width: 4,),
                                        Flexible(
                                          child: Text(
                                              "Moving",

                                              overflow: TextOverflow.ellipsis,
                                              style:TextStyle(
                                                fontSize: 10.0,
                                                color: Color(0xff003b46),
                                                fontWeight: FontWeight.w400,
                                              )
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default show a loading spinner.
                      return Center(child: CircularProgressIndicator(backgroundColor: Color(0xFFB4B4B4),valueColor:new AlwaysStoppedAnimation<Color>(Color(
                          0xFF7A0813)),));
                    }
                ),
              ),*/
        ),
      ),
    );
  }
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}


