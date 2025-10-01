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


  // GasCarrier   string   `json:"gas_carrier"`
  // WaterCarrier string   `json:"water_carrier"`
  // PowerCarrier string   `json:"power_carrier"`
  // Water        bool     `json:"water" gorm:"default:false"`
  // Gas          bool     `json:"gas" gorm:"default:false"`
  // Power        bool     `json:"power" gorm:"default:false"`

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
    );
  }

}
