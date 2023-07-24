class Order {
  final String id;
  final String vehicel_id;
  final String status;
  final String order_amount;
  final String customer_name;
  final String written_address;
  final String city;
  final double latitude;
  final double longitude;
  final DateTime time;
  final String power;
  final String speed;
  final String vlocation;
  final String payment_method;

  Order({
    required this.id,
    required this.vehicel_id,
    required this.status,
    required this.order_amount,
    required this.latitude,
    required this.longitude,
    required this.time,
    required this.power,
    required this.speed,
    required this.vlocation,
    required this.payment_method,
    required this.customer_name,
    required this.written_address,
    required this.city,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      vehicel_id: json['vehicel_id'],
      status: json['status'],
      order_amount: json['order_amount'],
      time: DateTime.parse(json['created_at']),
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      power: json['payment_method'],
      speed: json['city'],
      vlocation: json['store'],
      customer_name: json['customer_name'],
      payment_method: json['payment_method'],
      written_address: json['written_address'],
      city: json['city'],
    );
  }
}
