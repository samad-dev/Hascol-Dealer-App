class Order {
  final String id;
  final String delivery_based;
  final String depot;
  final String HSD_qty;
  final String PMG_qty;
  final String HOBC_qty;
  final String bank_info;
  final String start_time;
  final String vehicle;
  final String amount;
  final DateTime time;
  Order({
    required this.id,
    required this.delivery_based,
    required this.depot,
    required this.PMG_qty,
    required this.HSD_qty,
    required this.HOBC_qty,
    required this.bank_info,
    required this.start_time,
    required this.vehicle,
    required this.amount,
    required this.time,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      delivery_based: json['product_type'],
      depot: json['depot'],
      HOBC_qty: json['HOBC_qty'],
      HSD_qty: json['HSD_qty'],
      PMG_qty: json['PMG_qty'],
      bank_info: json['bank_info'],
      vehicle: json['vehicle'],
      start_time: json['start_time'],
      amount: json['amount'],
      time: DateTime.parse(json['date']),

    );
  }
}


class User {
  final String id;
  final String vehicel_id;
  final String email;
  final String name;

  User({
    required this.id,
    required this.vehicel_id,
    required this.email,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      vehicel_id: json['vehi_id'],
      email: json['email'],
      name: json['name'],
    );
  }
}
