class Service {
  final String id;
  final String name;
  final String description;
  final int price;
  final String type;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'type': type,
    };
  }
}
