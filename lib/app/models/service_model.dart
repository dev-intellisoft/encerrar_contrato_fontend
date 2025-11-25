class Service {
  String id;
  String name;
  String description;
  int price;
  String type;
  String companyName;
  bool selected;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.companyName,
    this.selected = false,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      type: json['type'] as String,
      companyName: json['company_name'] ?? '',
      selected: json['selected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'type': type,
      'company_name': companyName,
      'selected': selected,
    };
  }

  Service copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    String? type,
    String? companyName,
    bool? selected,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      type: type ?? this.type,
      companyName: companyName ?? this.companyName,
      selected: selected ?? this.selected,
    );
  }
}
