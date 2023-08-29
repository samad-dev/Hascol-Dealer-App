import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Playb extends StatefulWidget {
  final String vehicle_id,start_time;

  const Playb({super.key, required this.vehicle_id, required this.start_time});
  @override
  _PlaybState createState() => _PlaybState(vehicle_id,start_time);
}
class _PlaybState extends State<Playb> {
  final String vehicle_id,start_time;
  List<LatLng> latLen = [];
  List<Marker> markers = [];
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.8607, 67.0011),
    zoom: 14.4746,
  );
  final Set<Polyline> _polyline = {};

  _PlaybState(this.vehicle_id, this.start_time);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData(vehicle_id, start_time);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2b3993),
        title: Text('Track'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            polylines: _polyline,
            markers: Set.from(markers),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ],
      ),
    );
  }

  fetchData(vehicle_id,start_time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(
        'http://151.106.17.246:8080/hascol/api/get_routes.php?accesskey=12345&vehicle=21&start_time=2023-07-27%2019:17:52'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      List<LatLng> newLatLen =
      []; // Create a new list to store the updated LatLng points
      // print("Samad "+jsonResponse.length.toString());
      for (int a = 0; a < jsonResponse.length; a++) {
        double lat = double.parse(jsonResponse[a]['latitude'].toString());
        double lng = double.parse(jsonResponse[a]['longitude'].toString());
        print("Samad "+a.toString());
        newLatLen.add(LatLng(lat, lng));
        if (a == 0) {
          setState(() {
            markers.add(
              Marker(
                infoWindow: InfoWindow(title: 'Starting Point'),
                markerId: MarkerId('marker_1'),
                position:
                LatLng(lat, lng),
                // Latitude and longitude for Marker 1
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ),
            );
          });
        }
        if(a == jsonResponse.length-1){
          setState(() {
            markers.add(
              Marker(
                infoWindow: InfoWindow(title: 'Ending Point'),
                markerId: MarkerId('marker_2'),
                position:
                LatLng(lat, lng), // Latitude and longitude for Marker 1
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ),
            );
          });
        }
        // Add the new LatLng point to the list
      }

      setState(() {
        latLen = newLatLen; // Update the latLen list with the new LatLng points
        _polyline.clear();
        _polyline.add(Polyline(
          polylineId: PolylineId('1'),
          points: latLen,
          width: 5,
          color: Colors.red,
        ));


      });

      return;
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
  
  
}
