import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:pandamart/provider/navigator_provider.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/Order.dart';
import '../model/Vehicle.dart';
import '../styleguide/text_style.dart';
import '../widget/navigation_drawer_widget.dart';

class Create_Order extends StatefulWidget {
  const Create_Order({Key? key}) : super(key: key);

  @override
  State<Create_Order> createState() => _Order();
}

class _Order extends State<Create_Order> with SingleTickerProviderStateMixin {
  late Map<String, dynamic> jsonResponse;
  late Map<String, double> dataMap;
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  bool showProgress = true;
  List<Order> _foundUsers = [];
  String dropdownValue = "HSD";
  String dropdownValue1 = "Delivered";
  String dropdownValue2 = "Refinery";
  String dropdownValue3 = "NA";
  int hsd = 350;
  int hobc = 330;
  int pmg = 332;
  int hsdt = 0;
  int hobct = 0;
  int pmgt = 0;
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
  TextEditingController hsdController = new TextEditingController();
  TextEditingController pmgController = new TextEditingController();
  TextEditingController hobcController = new TextEditingController();
  TextEditingController depotController = new TextEditingController();
  TextEditingController bankController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  TextEditingController uidController = new TextEditingController();
  TextEditingController transactionController = new TextEditingController();
  TextEditingController vehicleController = new TextEditingController();
  TextEditingController tlcontroller = new TextEditingController();
  var _site = "Self";
  List data = []; //edited line
  List data2 = [];
  Future<String> getSWData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var user_id = await sharedPreferences.getString("userId");
    var res = await http.get(Uri.parse(
        "http://151.106.17.246:8080/hascol/api/dealer_depot.php?accesskey=12345&user_id=${user_id}"));
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
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM kk:mm:ss').format(now);
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: MaterialApp(
        title: "Orders",
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
            title: const Text("Create Orders"),
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
                    height: 10,
                  ),
                  Card(
                    color: Color(0xffF0F0F0),
                    elevation: 15,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.19,
                      height: 140,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //CircleAvatar
                            const SizedBox(
                              height: 10,
                            ), //SizedBox
                            Text(
                              'Account Balance',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.normal,
                              ),
                            ), //Text
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Color(0xff12283D),
                                    radius: 15,
                                    child: Icon(
                                      FontAwesomeIcons.cableCar,
                                      color: Colors.white,
                                      size: 15,
                                    ) //Text
                                    ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '3,75,000 Rs.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      'Updated On : ${formattedDate}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Color(0xff8A8A8A),
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            //SizedBox
                            //T //SizedBox
                            //SizedBox
                          ],
                        ), //Column
                      ), //Padding
                    ), //SizedBox,
                  ),
                  Card(
                    shape:
                        Border(left: BorderSide(color: Colors.red, width: 3)),
                    elevation: 10,
                    color: Color(0xffF0F0F0),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Product Information',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Color(0xff06298a)),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    width: 150,
                                    child: TextFormField(
                                      onFieldSubmitted: (value){
                                        print(value);
                                        setState(() {
                                          hsdt = int.parse(value)*350;
                                        });
                                      },
                                      onTapOutside: (value){
                                        print(value);
                                      },
                                      controller: hsdController,
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.poppins(
                                        color: Color(0xffa8a8a8),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      decoration: InputDecoration(
                                        hintStyle: GoogleFonts.poppins(
                                          color: Color(0xffa8a8a8),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        labelStyle: GoogleFonts.poppins(
                                          color: Color(0xffa8a8a8),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        filled: true,
                                        fillColor: Color(0xffF1F4FF),
                                        hintText: 'Quantity for HSD',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Color(0xff3b5fe0)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Color(0xffF1F4FF)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        labelText: 'HSD',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "x",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    hsd.toString(),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "=",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                   hsdt.toString(),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    width: 150,
                                    child: TextFormField(
                                      onFieldSubmitted: (value){
                                        print(value);
                                        setState(() {
                                          hobct = int.parse(value)*330;
                                        });
                                      },
                                      controller: hobcController,
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.poppins(
                                        color: Color(0xffa8a8a8),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      decoration: InputDecoration(
                                        hintStyle: GoogleFonts.poppins(
                                          color: Color(0xffa8a8a8),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        labelStyle: GoogleFonts.poppins(
                                          color: Color(0xffa8a8a8),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        filled: true,
                                        fillColor: Color(0xffF1F4FF),
                                        hintText: 'Quantity for HOBC',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Color(0xff3b5fe0)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Color(0xffF1F4FF)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        labelText: 'HOBC',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "x",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    hobc.toString(),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "=",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    hobct.toString(),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    width: 150,
                                    child: TextFormField(
                                      onFieldSubmitted: (value){
                                        print(value);
                                        setState(() {
                                          pmgt = int.parse(value)*332;
                                        });
                                      },
                                      controller: pmgController,
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.poppins(
                                        color: Color(0xffa8a8a8),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      decoration: InputDecoration(
                                        hintStyle: GoogleFonts.poppins(
                                          color: Color(0xffa8a8a8),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        labelStyle: GoogleFonts.poppins(
                                          color: Color(0xffa8a8a8),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        filled: true,
                                        fillColor: Color(0xffF1F4FF),
                                        hintText: 'Quantity for PMG',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Color(0xff3b5fe0)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Color(0xffF1F4FF)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        labelText: 'PMG',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "x",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    pmg.toString(),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "=",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    pmgt.toString(),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            /*Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Select Delivery Type",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                DropdownButton<String>(
                                  // value: dropdownValue,
                                  items: <String>["Delivered", "Self"]
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  value: dropdownValue1,
                                  hint: Text("Select"),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  // iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 13),
                                  // underline: Container(
                                  //   height: 2,
                                  //   color: Colors.deepPurpleAccent,
                                  // ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Select Depot",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                DropdownButton(
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 13),
                                  items: data.map((item) {
                                    return DropdownMenuItem(
                                      child: new Text(item['consignee_name']),
                                      value: item['consignee_name'].toString(),
                                    );
                                  }).toList(),
                                  onChanged: (String? newVal) {
                                    setState(() {
                                      _mySelection = newVal!;
                                      // print(_mySelection);
                                    });
                                  },
                                  value: _mySelection,
                                  hint: Text("Select Depot"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            TextFormField(
                              controller: quantityController,
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
                                  labelText: 'Quantity In Litres',
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
                                  'Bank Information',
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
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Select Bank",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                DropdownButton<String>(
                                  value: dropdownValue3,
                                  // value: "HBL Bank Ltd.",
                                  hint: Text('Select bank'),
                                  // icon: const Icon(Icons.arrow_downward),
                                  // iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 13),
                                  // underline: Container(
                                  //   height: 2,
                                  //   color: Colors.deepPurpleAccent,
                                  // ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue3 = newValue!;
                                    });
                                  },
                                  // value: dropdownValue3.toString(),
                                  items: <String>[
                                    'NA',
                                    'HBL Bank Ltd.',
                                    'Bank AL Habib',
                                    'MCB',
                                    'Silk Bank',
                                    'Askari Bank',
                                    'Bank Alfalah Limited',
                                    'National Bank',
                                    'Meezan Bank',
                                    'Faysal Bank (Islamic)',
                                    'Other'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            TextFormField(
                              controller: amountController,
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
                                  labelText: 'Enter Amount',
                                  labelStyle: TextStyle(
                                      fontSize: 15, color: Color(0xff06298a))),
                            ),
                            SizedBox(
                              height: 13,
                            ),*/
                            SizedBox(height: 10),
                            DropdownButton(
                              underline: Container(), //remove underline
                              isExpanded: true,
                              icon: Padding( //Icon at tail, arrow bottom is default icon
                                  padding: EdgeInsets.only(left:20),
                                  child:Icon(Icons.arrow_circle_down_sharp)
                              ),
                              iconEnabledColor: Colors.deepOrange,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 13),
                              items: data.map((item) {
                                return DropdownMenuItem(
                                  child: new Text(item['consignee_name'],style: GoogleFonts.poppins(
                                    color: Color(0xffa8a8a8),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                  ),),
                                  value: item['id'].toString(),
                                );
                              }).toList(),
                              onChanged: (String? newVal) {
                                setState(() {
                                  _mySelection = newVal!;
                                  // print(_mySelection);
                                });
                              },
                              value: _mySelection,
                              hint: Text("Select Depot",style: GoogleFonts.poppins(
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                fontStyle: FontStyle.normal,
                              ),),
                            ),
                            Column(
                              children: <Widget>[
                                ListTile(
                                  title: const Text('Self'),
                                  leading: Radio(
                                    value: "Self",
                                    groupValue: _site,
                                    onChanged: (value) {
                                      setState(() {
                                        _site = value!;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Company'),
                                  leading: Radio(
                                    value: "Company",
                                    groupValue: _site,
                                    onChanged: (value) {
                                      setState(() {
                                        _site = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (_site == "Self")
                              TextFormField(
                                controller: tlcontroller,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.poppins(
                                  color: Color(0xffa8a8a8),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                ),
                                decoration: InputDecoration(
                                  hintStyle: GoogleFonts.poppins(
                                    color: Color(0xffa8a8a8),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  labelStyle: GoogleFonts.poppins(
                                    color: Color(0xffa8a8a8),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xffF1F4FF),
                                  hintText: 'TL #',

                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Color(0xff3b5fe0)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Color(0xffF1F4FF)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  labelText: 'Enter TL #',
                                ),
                              ),
                            if (_site == "Company")
                              DropdownButton(
                                underline: Container(), //remove underline
                                isExpanded: true,
                                icon: Padding( //Icon at tail, arrow bottom is default icon
                                    padding: EdgeInsets.only(left:20),
                                    child:Icon(Icons.arrow_circle_down_sharp)
                                ),
                                iconEnabledColor: Colors.deepOrange,
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 13),
                                items: data.map((item) {
                                  return DropdownMenuItem(
                                    child: new Text(item['consignee_name'],style: GoogleFonts.poppins(
                                      color: Color(0xffa8a8a8),
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                    ),),
                                    value: item['id'].toString(),
                                  );
                                }).toList(),
                                onChanged: (String? newVal) {
                                  setState(() {
                                    _mySelection = newVal!;
                                    // print(_mySelection);
                                  });
                                },
                                value: _mySelection,
                                hint: Text("Select Depot",style: GoogleFonts.poppins(
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                ),),
                              ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: MaterialButton(
                                onPressed: () {
                                  uploaddata(
                                    hsdController.text.toString(),
                                    dropdownValue,
                                    dropdownValue1,
                                    _mySelection.toString(),
                                    dropdownValue3,
                                    amountController.text,
                                    context,
                                    hsdController.text.toString(),
                                    pmgController.text.toString(),
                                    hobcController.text.toString(),
                                  );
                                },
                                child: Text(
                                  'Create Order',
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
                            ),
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
}

uploaddata(String quantity, String ptype, String dbased, String depot,
    String bank, String amount, BuildContext context, hsdq, pmgq, hobcq) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var user_id = await sharedPreferences.getString("userId");
  print(
      "http://151.106.17.246:8080/hascol/api/hascol_orders.php?delivery_based=${dbased}&quantity=${quantity}&depot=${depot}&uid=${user_id}&bank=${bank}&product=${ptype}&amount=${amount}&traid&vehi=&image=&imei=&HSD_qty=${hsdq}&HOBC_qty=${hobcq}&PMG_qty=${pmgq}");
  var jsonResponce = null;
  // var responce = await http.post(Uri.parse("https://gariwala.pk/appapi/api/cus_reg.php?accesskey=12345&fname="+fName+"&address="+address+"&lname="+lName+"&number="+num+"&email="+email+"&user="+user+"&pass="+pass+"&state="+state+"&city="+city,)

  var response = await http.post(Uri.parse(
      "http://151.106.17.246:8080/hascol/api/hascol_orders.php?delivery_based=${dbased}&quantity=${quantity}&depot=${depot}&uid=${user_id}&bank=${bank}&product=${ptype}&amount=${amount}&traid&vehi=&image=&imei=&HSD_qty=${hsdq}&HOBC_qty=${hobcq}&PMG_qty=${pmgq}"));

  // if(jsonResponce.toString() == "{data: }"){
  if (jsonResponce.toString() != null) {
    print("if data is null : " + jsonResponce.toString());

    Fluttertoast.showToast(
        msg: "Order Generated Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    Fluttertoast.showToast(
        msg: "Order Not Generated",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
