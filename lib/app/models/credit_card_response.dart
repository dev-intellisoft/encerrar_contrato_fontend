class AsaaspaymentResponse {
  String? id;
  String? object;
  DateTime? dateCreated;
  String? customer;
  String? billingType;
  double? value;
  double? netValue;
  String? description;
  String? status;
  DateTime? dueDate;
  DateTime? originalDueDate;
  DateTime? clientPaymentDate;
  DateTime? confirmedDate;
  DateTime? creditDate;
  DateTime? estimatedCreditDate;
  bool? anticipable;
  bool? anticipated;
  bool? deleted;
  bool? postalService;
  String? invoiceNumber;
  String? invoiceUrl;
  String? transactionReceiptUrl;
  CreditCard? creditCard;

  AsaaspaymentResponse({
    this.id,
    this.object,
    this.dateCreated,
    this.customer,
    this.billingType,
    this.value,
    this.netValue,
    this.description,
    this.status,
    this.dueDate,
    this.originalDueDate,
    this.clientPaymentDate,
    this.confirmedDate,
    this.creditDate,
    this.estimatedCreditDate,
    this.anticipable,
    this.anticipated,
    this.deleted,
    this.postalService,
    this.invoiceNumber,
    this.invoiceUrl,
    this.transactionReceiptUrl,
    this.creditCard,
  });

  factory AsaaspaymentResponse.fromJson(Map<String, dynamic> json) {
    return AsaaspaymentResponse(
      id: json['id'],
      object: json['object'],
      dateCreated: DateTime.parse(json['dateCreated']),
      customer: json['customer'],
      billingType: json['billingType'],
      value: (json['value'] as num).toDouble(),
      netValue: (json['netValue'] as num).toDouble(),
      description: json['description'],
      status: json['status'],
      dueDate: DateTime.parse(json['dueDate']),
      originalDueDate: DateTime.parse(json['originalDueDate']),
      clientPaymentDate: json['clientPaymentDate'] != null
          ? DateTime.parse(json['clientPaymentDate'])
          : null,
      confirmedDate: json['confirmedDate'] != null
          ? DateTime.parse(json['confirmedDate'])
          : null,
      creditDate: json['creditDate'] != null
          ? DateTime.parse(json['creditDate'])
          : null,
      estimatedCreditDate: json['estimatedCreditDate'] != null
          ? DateTime.parse(json['estimatedCreditDate'])
          : null,
      anticipable: json['anticipable'],
      anticipated: json['anticipated'],
      deleted: json['deleted'],
      postalService: json['postalService'],
      invoiceNumber: json['invoiceNumber'],
      invoiceUrl: json['invoiceUrl'],
      transactionReceiptUrl: json['transactionReceiptUrl'],
      creditCard: CreditCard.fromJson(json['creditCard']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'object': object,
    'dateCreated': dateCreated?.toIso8601String(),
    'customer': customer,
    'billingType': billingType,
    'value': value,
    'netValue': netValue,
    'description': description,
    'status': status,
    'dueDate': dueDate?.toIso8601String(),
    'originalDueDate': originalDueDate?.toIso8601String(),
    'clientPaymentDate': clientPaymentDate?.toIso8601String(),
    'confirmedDate': confirmedDate?.toIso8601String(),
    'creditDate': creditDate?.toIso8601String(),
    'estimatedCreditDate': estimatedCreditDate?.toIso8601String(),
    'anticipable': anticipable,
    'anticipated': anticipated,
    'deleted': deleted,
    'postalService': postalService,
    'invoiceNumber': invoiceNumber,
    'invoiceUrl': invoiceUrl,
    'transactionReceiptUrl': transactionReceiptUrl,
    'creditCard': creditCard?.toJson(),
  };
}

class CreditCard {
  String? creditCardBrand;
  String? creditCardNumber;
  String? creditCardToken;

  CreditCard({
    this.creditCardBrand,
    this.creditCardNumber,
    this.creditCardToken,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) => CreditCard(
    creditCardBrand: json['creditCardBrand'],
    creditCardNumber: json['creditCardNumber'],
    creditCardToken: json['creditCardToken'],
  );

  Map<String, dynamic> toJson() => {
    'creditCardBrand': creditCardBrand,
    'creditCardNumber': creditCardNumber,
    'creditCardToken': creditCardToken,
  };
}
