class Order {
  final String id;
  final String delivery_based;
  final String depot;
  final String quantity;
  final String bank_info;
  final String amount;
  final DateTime time;
  Order({
    required this.id,
    required this.delivery_based,
    required this.depot,
    required this.quantity,
    required this.bank_info,
    required this.amount,
    required this.time,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      delivery_based: json['product_type'],
      depot: json['depot'],
      quantity: json['quantity'],
      bank_info: json['bank_info'],
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
