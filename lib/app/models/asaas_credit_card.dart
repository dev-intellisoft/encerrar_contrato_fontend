class ASAASCreditCard {
  String? holderName;
  String? number;
  String? expiryMonth;
  String? expiryYear;
  String? ccv;

  ASAASCreditCard({
    this.holderName,
    this.number,
    this.expiryMonth,
    this.expiryYear,
    this.ccv,
  });

  factory ASAASCreditCard.fromJson(Map<String, dynamic> json) {
    return ASAASCreditCard(
      holderName: json['holderName'] ?? '',
      number: json['number'] ?? '',
      expiryMonth: json['expiryMonth'] ?? '',
      expiryYear: json['expiryYear'] ?? '',
      ccv: json['ccv'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'holderName': holderName,
      'number': number,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'ccv': ccv,
    };
  }
}
