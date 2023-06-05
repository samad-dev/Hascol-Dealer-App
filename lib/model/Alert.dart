
class Alert {
  final String type;
  final String message;
  final String created_at;


  Alert({required this.type, required this.message, required this.created_at});

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      type: json['type'],
      message: json['message'],
      created_at: json['created_at'],
    );
  }
}

