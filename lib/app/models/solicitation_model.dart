import 'package:encerrar_contrato/app/models/asaas_credit_card.dart';
import 'package:encerrar_contrato/app/models/asaas_credit_card_holder_info.dart';
import 'package:encerrar_contrato/app/models/pix_model.dart';
import 'package:encerrar_contrato/app/models/service_model.dart';
import 'dart:typed_data';

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
  List<Service>? items = [];
  PIX? pix;
  String paymentType;
  String paymentStatus;
  String service;
  String? agencyId;
  String? agencyLogo;
  ASAASCreditCardHolderInfo? creditCardHolderInfo;
  ASAASCreditCard? creditCard;
  int? protocol;
  String? agency;
  bool water;
  bool gas;
  bool power;
  String? waterCarrier;
  String? gasCarrier;
  String? powerCarrier;

  Solicitation({
    this.id,
    this.customer,
    this.address,
    this.title,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.items,
    this.pix,
    this.paymentType = "pix",
    this.paymentStatus = "pending",
    this.service = "transfer",
    this.agencyId,
    this.agencyLogo,
    this.creditCardHolderInfo,
    this.creditCard,
    this.protocol,
    this.agency,
    this.water = false,
    this.gas = false,
    this.power = false,
    this.waterCarrier,
    this.gasCarrier,
    this.powerCarrier,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customer?.id,
      'title': title,
      'customer': (customer ?? Customer()).toJson(),
      'address': (address ?? Address()).toMap(),
      'description': description,
      'status': SolicitationStatus.pending.index,
      'items': items?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'pix': pix?.toJson(),
      'payment_type': paymentType,
      'payment_status': paymentStatus,
      'service': service,
      'agency_id': agencyId,
      'agency_logo': agencyLogo,
      'credit_card_holder_info': creditCardHolderInfo,
      'credit_card': creditCard,
      'protocol': protocol,
      'agency': agency,
      'water': water,
      'gas': gas,
      'power': power,
      'water_carrier': waterCarrier,
      'gas_carrier': gasCarrier,
      'power_carrier': powerCarrier,
    };
  }

  factory Solicitation.fromJson(Map<String, dynamic> map) {
    final rawStatus = map['status'];
    final statusIndex = rawStatus is int &&
            rawStatus >= 0 &&
            rawStatus < SolicitationStatus.values.length
        ? rawStatus
        : SolicitationStatus.pending.index;

    return Solicitation(
      id: map['id']?.toString(),
      customer: map['customer'] is Map<String, dynamic>
          ? Customer.fromJson(map['customer'])
          : Customer(),
      address: map['address'] is Map<String, dynamic>
          ? Address.fromMap(map['address'])
          : Address(),
      title: map['title'],
      description: map['description'],
      status: SolicitationStatus.values[statusIndex],
      createdAt: _parseDateTime(map['createdAt'] ?? map['created_at']),
      updatedAt: _parseDateTime(map['updatedAt'] ?? map['updated_at']),
      items: map['items'] != null
          ? (map['items'] as List)
                .map((e) => Service.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      pix: map['pix'] != null ? PIX.fromJson(map['pix']) : null,
      paymentType: map['payment_type']?.toString() ?? 'pix',
      paymentStatus: map['payment_status']?.toString() ?? 'pending',
      service: map['service']?.toString() ?? 'transfer',
      agencyId: map['agency_id']?.toString(),
      agencyLogo: map['agency_logo']?.toString(),
      creditCardHolderInfo: map['credit_card_holder_info'],
      creditCard: map['credit_card'],
      protocol: map['protocol'],
      agency: map['agency']?.toString(),
      water: map['water'] == true,
      gas: map['gas'] == true,
      power: map['power'] == true,
      waterCarrier: map['water_carrier']?.toString(),
      gasCarrier: map['gas_carrier']?.toString(),
      powerCarrier: map['power_carrier']?.toString(),
    );
  }

  List<Service> displayServices() {
    final normalizedItems = (items ?? <Service>[])
        .where(
          (item) =>
              item.selected ||
              (item.name ?? '').trim().isNotEmpty ||
              (item.companyName ?? '').trim().isNotEmpty,
        )
        .toList();

    if (normalizedItems.isNotEmpty) {
      return normalizedItems;
    }

    final derived = <Service>[];
    if (water) {
      derived.add(
        Service(name: 'Água', companyName: (waterCarrier ?? '').trim()),
      );
    }
    if (power) {
      derived.add(
        Service(name: 'Luz', companyName: (powerCarrier ?? '').trim()),
      );
    }
    if (gas) {
      derived.add(
        Service(name: 'Gás', companyName: (gasCarrier ?? '').trim()),
      );
    }
    return derived;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}

class Documents {
  Uint8List? documentPhotoByte;
  String? documentPhotoName;
  Uint8List? photoWithDocumentByte;
  String? photoWithDocumentName;
  Uint8List? lastInvoiceByte;
  String? lastInvoiceName;
  Uint8List? contractByte;
  String? contractName;
  Documents({
    this.documentPhotoByte,
    this.documentPhotoName,
    this.photoWithDocumentByte,
    this.photoWithDocumentName,
    this.lastInvoiceByte,
    this.lastInvoiceName,
    this.contractByte,
    this.contractName,
  });

  Map<String, dynamic> toJson() {
    return {
      'document_photo_byte': documentPhotoByte,
      'document_photo_name': documentPhotoName,
      'photo_with_document_byte': photoWithDocumentByte,
      'photo_with_document_name': photoWithDocumentName,
      'last_invoice_byte': lastInvoiceByte,
      'last_invoice_name': lastInvoiceName,
      'contract_byte': contractByte,
      'contract_name': contractName,
    };
  }

  factory Documents.fromJson(Map<String, dynamic> map) {
    return Documents(
      documentPhotoByte: map['document_photo_byte'],
      documentPhotoName: map['document_photo_name'],
      photoWithDocumentByte: map['photo_with_document_byte'],
      photoWithDocumentName: map['photo_with_document_name'],
      lastInvoiceByte: map['last_invoice_byte'],
      lastInvoiceName: map['last_invoice_name'],
      contractByte: map['contract_byte'],
      contractName: map['contract_name'],
    );
  }
}
