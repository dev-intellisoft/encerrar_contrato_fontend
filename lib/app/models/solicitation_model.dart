import 'package:encerrar_contrato/app/models/asaas_credit_card.dart';
import 'package:encerrar_contrato/app/models/asaas_credit_card_holder_info.dart';
import 'package:encerrar_contrato/app/models/pix_model.dart';
import 'package:encerrar_contrato/app/models/service_model.dart';

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
  List<Service>? services = [];
  PIX? pix;
  String paymentType = "pix";
  String paymentStatus = "pending";
  String service = "close";
  String? agencyId;
  String? agencyLogo;
  ASAASCreditCardHolderInfo? creditCardHolderInfo;
  ASAASCreditCard? creditCard;

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
    this.pix,
    this.paymentType = "pix",
    this.paymentStatus = "pending",
    this.service = "close",
    this.agencyId,
    this.agencyLogo,
    this.creditCardHolderInfo,
    this.creditCard,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customer != null ? customer!.id : "",
      'title': title,
      'customer': customer!.toJson(),
      'address': address!.toMap(),
      'description': description,
      'status': SolicitationStatus.pending.index,
      'services': services?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'pix': pix?.toJson(),
      'payment_type': paymentType,
      'payment_status': paymentStatus,
      'service': service,
      'agency_id': agencyId,
      'agency_logo': agencyLogo,
      'credit_card_holder_info': creditCardHolderInfo,
      'credit_card': creditCard,
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
      services: map['services'] != null
          ? (map['services'] as List)
                .map((e) => Service.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      pix: map['pix'] != null ? PIX.fromJson(map['pix']) : null,
      paymentType: map['payment_type'],
      paymentStatus: map['payment_status'],
      service: map['service'],
      agencyId: map['agency_id'],
      agencyLogo: map['agency_logo'],
      creditCardHolderInfo: map['credit_card_holder_info'],
      creditCard: map['credit_card'],
    );
  }
}
