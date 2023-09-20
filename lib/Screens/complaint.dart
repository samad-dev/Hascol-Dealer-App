import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class Create_Comp extends StatefulWidget {
  const Create_Comp({Key? key}) : super(key: key);

  @override
  State<Create_Comp> createState() => _Comp();
}

class _Comp extends State<Create_Comp> with SingleTickerProviderStateMixin {
  late Map<String, dynamic> jsonResponse;
  late Map<String, double> dataMap;
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  bool showProgress = true;
  List<Order> _foundUsers = [];
  String dropdownValue = "HSD";
  String dropdownValue1 = "Delivered";
  String dropdownValue2 = "Refinery";
  String dropdownValue3 = "NA";
  late Future<List<Order>> futureAlbum;
  String number = "";
  List<String> buttonTexts = [];
  late List<Order> items1;
  TextEditingController cancel_controller = new TextEditingController();
  TextEditingController collect_controller = new TextEditingController();
  bool status = false;
  String? _currentAddress;
  Position? _currentPosition;
  String? _mySelection;
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController subject = new TextEditingController();
  TextEditingController message = new TextEditingController();

  List data = []; //edited line
  var namec,emailx;
  Future<String> getSWData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     namec = await sharedPreferences.getString("user_name");
     emailx = await sharedPreferences.getString("email");
    print("Samad"+namec.toString());
    setState(() {
       name.text = namec!;
       email.text = emailx!;
    });
    var res = await http.get(Uri.parse(
        "http://151.106.17.246:8080/hascol/api/all_depot.php?accesskey=12345"));
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    // print(data[0]["id"]);
    // print("Sapcode " + code.toString());

    return Future.value("Data download successfully");
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
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: MaterialApp(
        title: "Complaints",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: const Color(0xff06298a),
            title: const Text("Create Complaint"),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
            ),
            child: Padding(
              padding: EdgeInsets.all(3),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Card(
                    shape:
                    Border(left: BorderSide(color: Colors.red, width: 3)),
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
                                  'User Information',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Color(0xff06298a)),
                                )
                              ],
                            ),
                            TextFormField(
                              controller: name,
                              keyboardType: TextInputType.text,
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
                                  labelText: 'Enter Name',
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Color(0xff06298a))),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            TextFormField(
                              enabled: false,
                              controller: email,
                              keyboardType: TextInputType.text,
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
                                  labelText: 'Enter Email',
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Color(0xff06298a))),
                            ),

                            SizedBox(
                              height: 13,
                            ),
                            TextFormField(
                              controller: phone,
                              keyboardType: TextInputType.number,
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
                                  labelText: 'Enter Phone',
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Color(0xff06298a))),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Complaint Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Color(0xff06298a)),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            TextFormField(
                              controller: subject,
                              keyboardType: TextInputType.text,
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
                                  labelText: 'Enter Subject',
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Color(0xff06298a))),
                            ),
                            SizedBox(
                              height: 13,
                            ),


                            TextFormField(
                              controller: message,
                              keyboardType: TextInputType.multiline,
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
                                  labelText: 'Enter Message',
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Color(0xff06298a))),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: MaterialButton(
                                onPressed: () {
                                  uploaddata(namec,emailx,phone.text.toString(),subject.text.toString(),message.text.toString());
                                },
                                child: Text(
                                  'Create Complaint',
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

  uploaddata(name,email,phone2,subject2,message2) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var user_id = await sharedPreferences.getString("userId");
    print("http://151.106.17.246:8080/hascol/api/placed_complaint.php?name=${name}&email=${email}&phone=${phone2}&priority=high&subject=${subject2}&message=${message2}&user_id=${user_id}");
    var jsonResponce = null;
    // var responce = await http.post(Uri.parse("https://gariwala.pk/appapi/api/cus_reg.php?accesskey=12345&fname="+fName+"&address="+address+"&lname="+lName+"&number="+num+"&email="+email+"&user="+user+"&pass="+pass+"&state="+state+"&city="+city,)

    var response = await http.post(Uri.parse("http://151.106.17.246:8080/hascol/api/placed_complaint.php?name=${name}&email=${email}&phone=${phone2}&priority=high&subject=${subject2}&message=${message2}&user_id=${user_id}"));

    // if(jsonResponce.toString() == "{data: }"){
    if (jsonResponce.toString() != null) {
      print("if data is null : " + jsonResponce.toString());
      phone.text = "";
      subject.text = "";
      message.text = "";
      Fluttertoast.showToast(
          msg: "Complaint Generated Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    else
    { Fluttertoast.showToast(
        msg: "Complaint Not Generated",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    }
  }
}


