class Address {
  String? id;
  String? street;
  String? number;
  String? complement;
  String? neighborhood;
  String? city;
  String? state;
  String? country;
  String? zipCode;

  Address({
    this.id,
    this.street,
    this.number,
    this.complement,
    this.neighborhood,
    this.city,
    this.state,
    this.country,
    this.zipCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      street: map['street'],
      number: map['number'],
      complement: map['complement'],
      neighborhood: map['neighborhood'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      zipCode: map['zipCode'],
    );
  }

  factory Address.fromViaCEP(Map<String, dynamic> map) {
    return Address(
      zipCode: map['cep'],
      street: map['logradouro'],
      neighborhood: map['bairro'],
      city: map['localidade'],
      state: map['uf'],
      country: 'Brasil',
    );
  }
}
