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
  List<Service>? services = [];
  PIX? pix;
  String paymentType;
  String paymentStatus;
  String service;
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
    this.service = "transfer",
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
