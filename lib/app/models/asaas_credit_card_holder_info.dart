class ASAASCreditCardHolderInfo {
  String? name;
  String? email;
  String? cpfCnpj;
  String? postalCode;
  String? addressNumber;
  String? phone;

  ASAASCreditCardHolderInfo({
     this.name,
     this.email,
     this.cpfCnpj,
     this.postalCode,
     this.addressNumber,
     this.phone,
  });

  factory ASAASCreditCardHolderInfo.fromJson(Map<String, dynamic> json) {
    return ASAASCreditCardHolderInfo(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      cpfCnpj: json['cpfCnpj'] ?? '',
      postalCode: json['postalCode'] ?? '',
      addressNumber: json['addressNumber'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'cpfCnpj': cpfCnpj,
      'postalCode': postalCode,
      'addressNumber': addressNumber,
      'phone': phone,
    };
  }
}
