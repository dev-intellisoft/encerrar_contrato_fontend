import 'package:intl/intl.dart';

class Customer {
  String? id;
  String? name;
  String? cpf;
  String? birthDate;
  String? email;
  String? phone;
  String? confirmPhone;

  Customer({
    this.id,
    this.name,
    this.cpf,
    this.email,
    this.phone,
    this.confirmPhone,
    this.birthDate,
  });

  Map<String, dynamic> toJson() {
    final rawBirthDate = (birthDate ?? '').trim();
    final bd = rawBirthDate.isEmpty
        ? ''
        : rawBirthDate.split('/').reversed.join('-');
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'email': email,
      'phone': phone,
      'confirm_phone': confirmPhone,
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
      confirmPhone: map['confirm_phone'],
      birthDate: map['birth_date'],
    );
  }
}
