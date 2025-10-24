import 'package:intl/intl.dart';

class Customer {
  String? id;
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
    String bd = birthDate!.split('/').reversed.join('-');
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'email': email,
      'phone': phone,
      'birth_date': bd,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      cpf: map['cpf'],
      email: map['email'],
      phone: map['phone'],
      birthDate: map['birth_date'],
    );
  }
}
