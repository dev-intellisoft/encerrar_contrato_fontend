import 'package:encerrar_contrato/app/models/pix_model.dart';

import 'customer_model.dart';

import 'address_model.dart';

enum SolicitationStatus { pending, processing, done }

class Solicitation {
  String? id;
  Customer? customer;
  Address? address;
  String? title;
  String? description;
  SolicitationStatus? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? services;
  String? agency;
  String? gasCarrier;
  String? waterCarrier;
  String? powerCarrier;
  bool water;
  bool gas;
  bool power;
  PIX? pix;
  String paymentType = "pix";
  String paymentStatus = "pending";
  String service = "close";
  String? agencyId;

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
    this.gasCarrier,
    this.waterCarrier,
    this.powerCarrier,
    this.water = false,
    this.gas = false,
    this.power = false,
    this.pix,
    this.paymentType = "pix",
    this.paymentStatus = "pending",
    this.service = "close",
    this.agencyId
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id':customer != null ? customer!.id:"",
      'title': title,
      'customer':customer!.toJson(),
      'address':address!.toMap(),
      'description': description,
      'status': SolicitationStatus.pending.index,
      'agency': agency,
      'services': services,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'gas_carrier': gasCarrier,
      'water_carrier': waterCarrier,
      'power_carrier': powerCarrier,
      'water': water,
      'gas': gas,
      'power': power,
      'pix': pix?.toJson(),
      'payment_type': paymentType,
      'payment_status':paymentStatus,
      'service':service,
      'agency_id':agencyId
    };
  }

  factory Solicitation.fromJson(Map<String, dynamic> map) {
    return Solicitation(
      id: map['id'],
      customer: Customer.fromJson(map['customer']),
      address: Address.fromMap(map['address']),
      title: map['title'],
      description: map['description'],
      status: SolicitationStatus.values[map['status']],
      services: map['services'],
      agency: map['agency'],
      gasCarrier: map['gas_carrier'],
      waterCarrier: map['water_carrier'],
      powerCarrier: map['power_carrier'],
      water: map['water'],
      gas: map['gas'],
      power: map['power'],
      pix: map['pix'] != null?PIX.fromJson(map['pix']):null,
      paymentType: map['payment_type'],
      paymentStatus: map['payment_status'],
      service: map['service'],
      agencyId: map['agency_id'],
    );
  }
}
