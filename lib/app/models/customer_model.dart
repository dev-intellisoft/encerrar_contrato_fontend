class Customer {
  BigInt? id;
  String? name;
  String? cpf;
  String? birthDate;
  String? email;
  String? phone;

  Customer({
    this.id,
    this.name,
    this.cpf,
    this.email,
    this.phone,
    this.birthDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'email': email,
      'phone': phone,
      'birthDate': birthDate,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> map) {
    return Customer(
      id: BigInt.tryParse('${map['id']}')??BigInt.zero,
      name: map['name'],
      cpf: map['cpf'],
      email: map['email'],
      phone: map['phone'],
      birthDate: map['birth_date'],
    );
  }
}
