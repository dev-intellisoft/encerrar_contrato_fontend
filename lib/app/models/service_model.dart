class Service {
  String? id;
  String? name;
  String? description;
  int? price;
  String? type;
  String? companyName;
  bool selected;

  Service({
    this.id,
    this.name,
    this.description,
    this.price,
    this.type,
    this.companyName,
    this.selected = false,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      price: json['price'] is int
          ? json['price'] as int
          : (json['price'] is num ? (json['price'] as num).toInt() : null),
      type: json['type']?.toString(),
      companyName: json['company_name']?.toString() ?? '',
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
