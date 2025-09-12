import 'customer_model.dart';

import 'address_model.dart';

enum SolicitationStatus { pending, processing, done }

class Solicitation {
  BigInt? id;
  Customer? customer;
  Address? address;
  String? title;
  String? description;
  SolicitationStatus? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? services;
  String? agency;

  Solicitation({
    this.id,
    this.customer,
    this.address,
    this.title,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.services,
    this.agency,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': BigInt.tryParse('$id')??BigInt.zero,
      'customer_id':customer != null ? customer!.id:BigInt.zero,
      'title': title,
      'customer':customer!.toJson(),
      'address':address!.toMap(),
      'description': description,
      'status': SolicitationStatus.pending.index,
      'agency': agency,
      'services': services,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Solicitation.fromJson(Map<String, dynamic> map) {
    return Solicitation(
      id: BigInt.tryParse('${map['id']}')??BigInt.zero,
      customer: Customer.fromJson(map['customer']),
      address: Address.fromMap(map['address']),
      title: map['title'],
      description: map['description'],
      status: SolicitationStatus.values[map['status']],
      services: map['services'],
      agency: map['agency'],
    );
  }

}
