
class Vehicle {
  final String id;
  final String name;
  final String vstatus1;
  final String vehicle_make;
  final double latitude;
  final double longitude;
  final DateTime time;
  final String power;
  final String speed;
  final String vlocation;

  Vehicle({required this.id,required this.name, required this.vstatus1, required this.vehicle_make, required this.latitude, required this.longitude, required this.time, required this.power, required this.speed, required this.vlocation});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id:json['id'],
      name: json['name'],
      vstatus1: json['imei'],
      vehicle_make: json['angle'],
      time: DateTime.parse(json['time']),
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['lng']),
      power: json['ignition'],
      speed: json['speed'],
      vlocation: json['location'],
    );
  }
}

class Drivers_M {
  String s0;
  String s1;
  String s2;
  String s3;
  String s4;
  String s5;
  String s6;
  String s7;
  String s8;
  String s9;
  String s10;
  String id;
  String sNo;
  String date;
  String name;
  String sonOf;
  String cnic;
  String contact;
  String licence;
  String trainingPlace;
  String createdAt;
  String createdBy;

  Drivers_M(
      { required this.s0,
        required this.s1,
        required this.s2,
        required this.s3,
        required this.s4,
        required this.s5,
        required this.s6,
        required this.s7,
        required this.s8,
        required this.s9,
        required this.s10,
        required this.id,
        required this.sNo,
        required this.date,
        required this.name,
        required this.sonOf,
        required this.cnic,
        required this.contact,
        required this.licence,
        required this.trainingPlace,
        required this.createdAt,
        required this.createdBy});

  factory Drivers_M.fromJson(Map<String, dynamic> json) {
    return Drivers_M(
    s0 : json['0'],
    s1 : json['1'],
    s2 : json['2'],
    s3 : json['3'],
    s4 : json['4'],
    s5 : json['5'],
    s6 : json['6'],
    s7 : json['7'],
    s8 : json['8'],
    s9 : json['9'],
    s10 : json['10'],
    id : json['id'],
    sNo : json['s_no'],
    date : json['date'],
    name : json['name'],
    sonOf : json['son_of'],
    cnic : json['cnic'],
    contact : json['contact'],
    licence : json['licence'],
    trainingPlace : json['training_place'],
    createdAt : json['created_at'],
    createdBy : json['created_by']
    );
  }


}