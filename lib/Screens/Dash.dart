import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:pandamart/provider/navigator_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
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
  late Map<String, dynamic> jsonResponse;
  late Map<String, double> dataMap;
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  bool showProgress = true;
  List<Order> _foundUsers = [];
  late Future<List<Order>> futureAlbum;
  String number = "";
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
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final response = await http.get(Uri.parse(
        'http://151.106.17.246:8080/pandamart_close/api/mart_disparched_orders.php?accesskey=12345&user_id=3'));
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
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: _foundUsers
                                .length, // set the number of items in the list
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: const Color(0xffff2d55),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                child: GestureDetector(
                                  onTap: () {
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
                                                    "Start Delivery",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
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
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .red)),
                                                        onPressed: () {
                                                          openMap(-3.823216,
                                                              -38.481700);
                                                          print('samad');
                                                        },
                                                        child: Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Nunito',
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .grey)),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        child: Text(
                                                          "No",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Nunito',
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                            const Duration(milliseconds: 200),
                                        barrierDismissible: false,
                                        barrierLabel: '',
                                        context: context,
                                        pageBuilder:
                                            (context, animation1, animation2) {
                                          return const Text('PAGE BUILDER');
                                        });
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          "Customer Name: " +
                                              _foundUsers[index].customer_name,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
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
                                                  "Payment Method:",
                                                  style:
                                                      whiteSubHeadingTextStyle
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  _foundUsers[index].power,
                                                  style:
                                                      whiteSubHeadingTextStyle
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
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
                                                                  Colors.white,
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
                                                                  Colors.white,
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
                                        trailing: SizedBox(
                                          width: 55,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.payment,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Rs.${_foundUsers[index].order_amount}",
                                                          style: whiteSubHeadingTextStyle
                                                              .copyWith(
                                                                  color: Color(
                                                                      0xffffffff),
                                                                  fontSize: 12),
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
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Icon(
                                            Icons.location_on,
                                            color: Color(0xffffffff),
                                            size: 13,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Flexible(
                                            child: Text(
                                                _foundUsers[index].vlocation,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: Color(0xffffffff),
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
                                            Icons.visibility,
                                            color: Colors.white,
                                            size: 13,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Flexible(
                                            child: Text(
                                                "${_foundUsers[index].written_address}",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
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
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              foregroundColor:
                                                  MaterialStateProperty
                                                      .all<Color>(Colors
                                                          .pinkAccent.shade200),
                                            ),
                                            onPressed: () {
                                              if (status == false) {
                                                showGeneralDialog(
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.5),
                                                    transitionBuilder: (context,
                                                        a1, a2, widget) {
                                                      return Transform.scale(
                                                        scale: a1.value,
                                                        child: Opacity(
                                                            opacity: a1.value,
                                                            child: AlertDialog(
                                                              title: Text(
                                                                "Start Delivery",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              actionsAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              content: Text(
                                                                "Are you sure you want to Start Delivery?",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                                                            MaterialStateProperty.all(Colors
                                                                                .red)),
                                                                    onPressed:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        status =
                                                                            true;
                                                                      });
                                                                      DateTime
                                                                          current_date =
                                                                          DateTime
                                                                              .now();

                                                                      print(
                                                                          'http://151.106.17.246:8080/pandamart_close/api/trip_start.php?orderid=${_foundUsers[index].id}&start_time=${current_date.toString()}');
                                                                      var request = http.Request(
                                                                          'GET',
                                                                          Uri.parse(
                                                                              'http://151.106.17.246:8080/pandamart_close/api/trip_start.php?orderid=${_foundUsers[index].id}&start_time=${current_date.toString()}'));

                                                                      http.StreamedResponse
                                                                          response =
                                                                          await request
                                                                              .send();

                                                                      if (response
                                                                              .statusCode ==
                                                                          200) {
                                                                        var resp = await response
                                                                            .stream
                                                                            .bytesToString();
                                                                        print(
                                                                            resp);
                                                                        if (resp ==
                                                                            'successfully !') {
                                                                          Navigator.pop(
                                                                              context);
                                                                          openMap(
                                                                              -3.823216,
                                                                              -38.481700);
                                                                          print(
                                                                              'samad');
                                                                        }
                                                                      } else {
                                                                        print(response
                                                                            .reasonPhrase);
                                                                      }
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
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.03,
                                                                      ),
                                                                    )),
                                                                TextButton(
                                                                    style: ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all(Colors
                                                                                .grey)),
                                                                    onPressed: () =>
                                                                        Navigator.of(context)
                                                                            .pop(false),
                                                                    child: Text(
                                                                      "No",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
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
                                                    pageBuilder: (context,
                                                        animation1,
                                                        animation2) {
                                                      return const Text(
                                                          'PAGE BUILDER');
                                                    });
                                              } else {
                                                showGeneralDialog(
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.5),
                                                    transitionBuilder: (context,
                                                        a1, a2, widget) {
                                                      return Transform.scale(
                                                        scale: a1.value,
                                                        child: Opacity(
                                                            opacity: a1.value,
                                                            child: AlertDialog(
                                                              title: Column(
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    mainAxisAlignment: MainAxisAlignment.center,

                                                                    children: [

                                                                      Text(
                                                                        "End Delivery",
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w800,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                SfSignaturePad(
                                                                              key:
                                                                                  _signaturePadKey,
                                                                              minimumStrokeWidth:
                                                                                  1,
                                                                              maximumStrokeWidth:
                                                                                  3,
                                                                              strokeColor:
                                                                                  Colors.blue,
                                                                              backgroundColor:
                                                                                  Colors.grey,
                                                                            ),
                                                                            height:
                                                                                200,
                                                                            width:
                                                                                232,
                                                                          ),
                                                                          /*if(_foundUsers[index].payment_method == 'Cash On Delivery')
                                                                          TextField(controller: cancel_controller, style:
                                                                          TextStyle(
                                                                            fontWeight:
                                                                            FontWeight.w400,
                                                                            fontSize:
                                                                            12,
                                                                          ),)*/
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  if(_foundUsers[index].payment_method == 'Cash On Delivery')
                                                                      Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        mainAxisAlignment: MainAxisAlignment.center,

                                                                        children: [

                                                                          Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "Cash To Be Collected",
                                                                                    style:
                                                                                    TextStyle(
                                                                                      fontWeight:
                                                                                      FontWeight.w800,
                                                                                      fontSize:
                                                                                      16,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "Rs ${_foundUsers[index].order_amount}",
                                                                                    style:
                                                                                    TextStyle(
                                                                                      fontWeight:
                                                                                      FontWeight.w800,
                                                                                      fontSize:
                                                                                      16,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),

                                                                              /*Row(
                                                                                children: [
                                                                                  TextField(
                                                                                    controller: cancel_controller,
                                                                                    style:
                                                                                    TextStyle(
                                                                                      fontWeight:
                                                                                      FontWeight.w800,
                                                                                      fontSize:
                                                                                      16,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),*/
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )


                                                                ],
                                                              ),
                                                              actionsAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              content: Text(
                                                                "Are you sure you want to End Delivery?",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                                                            MaterialStateProperty.all(Colors
                                                                                .red)),
                                                                    onPressed:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        status =
                                                                            true;
                                                                      });
                                                                      DateTime
                                                                          current_date =
                                                                          DateTime
                                                                              .now();
                                                                      var request = http.Request(
                                                                          'GET',
                                                                          Uri.parse(
                                                                              'http://151.106.17.246:8080/pandamart_close/api/trip_close_by_driver.php?orderid=${_foundUsers[index].id}&close_time=${current_date.toLocal().toString()}&lat_lng=${_currentPosition!.latitude.toString()} ${_currentPosition!.longitude.toString()}'));
                                                                      ui.Image
                                                                          image =
                                                                          await _signaturePadKey
                                                                              .currentState!
                                                                              .toImage();
                                                                      ByteData?
                                                                          byteData =
                                                                          await (image.toByteData(
                                                                              format: ui.ImageByteFormat.png));
                                                                      if (byteData !=
                                                                          null) {
                                                                        final result = await ImageGallerySaver.saveImage(byteData
                                                                            .buffer
                                                                            .asUint8List());
                                                                        print(
                                                                            result);
                                                                      }

                                                                      http.StreamedResponse
                                                                          response =
                                                                          await request
                                                                              .send();

                                                                      if (response
                                                                              .statusCode ==
                                                                          200) {
                                                                        var res2 = await response
                                                                            .stream
                                                                            .bytesToString();
                                                                        if (res2 ==
                                                                            'successfully !') {
                                                                          Navigator.pop(
                                                                              context);
                                                                          if(_foundUsers[index].payment_method == 'Cash On Delivery')
                                                                          showGeneralDialog(
                                                                              barrierColor: Colors.black
                                                                                  .withOpacity(0.5),
                                                                              transitionBuilder: (context,
                                                                                  a1, a2, widget) {
                                                                                return Transform.scale(
                                                                                  scale: a1.value,
                                                                                  child: Opacity(
                                                                                      opacity: a1.value,
                                                                                      child: AlertDialog(
                                                                                        title: Column(
                                                                                          children: [
                                                                                            Row(
                                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,

                                                                                              children: [

                                                                                                Text(
                                                                                                  "Enter Collected Amount",
                                                                                                  style:
                                                                                                  TextStyle(
                                                                                                    fontWeight:
                                                                                                    FontWeight.w800,
                                                                                                    fontSize:
                                                                                                    16,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Column(
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      child:
                                                                                                      TextFormField(
                                                                                                        keyboardType: TextInputType.number,
                                                                                                        controller: collect_controller,),
                                                                                                      height:
                                                                                                      50,
                                                                                                      width:
                                                                                                      232,
                                                                                                    ),

                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),



                                                                                          ],
                                                                                        ),
                                                                                        actionsAlignment:
                                                                                        MainAxisAlignment
                                                                                            .spaceAround,

                                                                                        actions: <Widget>[
                                                                                          TextButton(
                                                                                              style: ButtonStyle(
                                                                                                  backgroundColor:
                                                                                                  MaterialStateProperty.all(Colors
                                                                                                      .grey)),
                                                                                              onPressed: () =>
                                                                                                  Navigator.of(context)
                                                                                                      .pop(false),
                                                                                              child: Text(
                                                                                                "Submit",
                                                                                                style:
                                                                                                TextStyle(
                                                                                                  color: Colors
                                                                                                      .white,
                                                                                                  fontFamily:
                                                                                                  'Nunito',
                                                                                                  fontWeight:
                                                                                                  FontWeight.w600,
                                                                                                  fontSize:
                                                                                                  MediaQuery.of(context).size.width *
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
                                                                              pageBuilder: (context,
                                                                                  animation1,
                                                                                  animation2) {
                                                                                return const Text(
                                                                                    'PAGE BUILDER');
                                                                              });
                                                                          final snackBar =
                                                                              SnackBar(
                                                                            content:
                                                                                Text('Delivery Completed Successfully'),
                                                                            duration:
                                                                                Duration(seconds: 5),
                                                                            action:
                                                                                SnackBarAction(
                                                                              label: 'Undo',
                                                                              onPressed: () {
                                                                                // Some code to undo the change.
                                                                              },
                                                                            ),
                                                                          );
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(snackBar);
                                                                        }
                                                                      } else {
                                                                        print(response
                                                                            .reasonPhrase);
                                                                      }
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
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.03,
                                                                      ),
                                                                    )),
                                                                TextButton(
                                                                    style: ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all(Colors
                                                                                .grey)),
                                                                    onPressed: () =>
                                                                        Navigator.of(context)
                                                                            .pop(false),
                                                                    child: Text(
                                                                      "No",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width *
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
                                                    pageBuilder: (context,
                                                        animation1,
                                                        animation2) {
                                                      return const Text(
                                                          'PAGE BUILDER');
                                                    });
                                              }
                                            },
                                            child: Text(status == true
                                                ? 'End Delivery'
                                                : 'Start Delivery'),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              foregroundColor:
                                                  MaterialStateProperty
                                                      .all<Color>(Colors
                                                          .pinkAccent.shade200),
                                            ),
                                            onPressed: () {
                                              showGeneralDialog(
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.5),
                                                  transitionBuilder: (context,
                                                      a1, a2, widget) {
                                                    return Transform.scale(
                                                      scale: a1.value,
                                                      child: Opacity(
                                                          opacity: a1.value,
                                                          child: AlertDialog(
                                                            title: Text(
                                                              "Cancel Order",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            actionsAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            content: Text(
                                                              "Are you sure you want to Cancel Order?",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                                                          MaterialStateProperty.all(Colors
                                                                              .red)),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            false);
                                                                    showGeneralDialog(
                                                                        barrierColor: Colors.black
                                                                            .withOpacity(0.5),
                                                                        transitionBuilder: (context,
                                                                            a1, a2, widget) {
                                                                          return Transform.scale(
                                                                            scale: a1.value,
                                                                            child: Opacity(
                                                                                opacity: a1.value,
                                                                                child: AlertDialog(
                                                                                  title: Text(
                                                                                    "Add Note",
                                                                                    style: TextStyle(
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w400,
                                                                                      fontSize: 12,
                                                                                    ),
                                                                                  ),
                                                                                  actionsAlignment:
                                                                                  MainAxisAlignment
                                                                                      .spaceAround,
                                                                                  content: TextField(
                                                                                    controller: cancel_controller,
                                                                                    style: TextStyle(
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .w600,
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
                                                                                            MaterialStateProperty.all(Colors
                                                                                                .red)),
                                                                                        onPressed:
                                                                                            () {
                                                                                          Navigator.of(
                                                                                              context)
                                                                                              .pop(
                                                                                              false);

                                                                                        },
                                                                                        child: Text(
                                                                                          "Submit",
                                                                                          style:
                                                                                          TextStyle(
                                                                                            color: Colors
                                                                                                .white,
                                                                                            fontFamily:
                                                                                            'Nunito',
                                                                                            fontWeight:
                                                                                            FontWeight
                                                                                                .w600,
                                                                                            fontSize: MediaQuery.of(context)
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
                                                                        pageBuilder: (context,
                                                                            animation1, animation2) {
                                                                          return const Text(
                                                                              'PAGE BUILDER');
                                                                        });
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
                                                                      fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.03,
                                                                    ),
                                                                  )),
                                                              TextButton(
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(Colors
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
                                                                      fontSize: MediaQuery.of(context)
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
                                                  pageBuilder: (context,
                                                      animation1, animation2) {
                                                    return const Text(
                                                        'PAGE BUILDER');
                                                  });
                                            },
                                            child: Text('Cancel Order'),
                                          ),
                                          /*SizedBox(
                                            width: 5,
                                          ),*/
                                          /*TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              foregroundColor:
                                                  MaterialStateProperty
                                                      .all<Color>(Colors
                                                          .pinkAccent.shade200),
                                            ),
                                            onPressed: () {
                                              showGeneralDialog(
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.5),
                                                  transitionBuilder: (context,
                                                      a1, a2, widget) {
                                                    return Transform.scale(
                                                      scale: a1.value,
                                                      child: Opacity(
                                                          opacity: a1.value,
                                                          child: AlertDialog(
                                                            title: Text(
                                                              "Cash On Delivery",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            actionsAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            content: Text(
                                                              "Are you sure you want to Cancel Order?",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
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
                                                                      MaterialStateProperty.all(Colors
                                                                          .red)),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop(
                                                                        false);

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
                                                                      fontSize: MediaQuery.of(context)
                                                                          .size
                                                                          .width *
                                                                          0.03,
                                                                    ),
                                                                  )),
                                                              TextButton(
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty.all(Colors
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
                                                                      fontSize: MediaQuery.of(context)
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
                                                  pageBuilder: (context,
                                                      animation1, animation2) {
                                                    return const Text(
                                                        'PAGE BUILDER');
                                                  });
                                            },
                                            child: Text('COD'),
                                          )*/
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
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

        ),
      ),
    );
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
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
