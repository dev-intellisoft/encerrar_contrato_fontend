// import 'dart:io';
import 'dart:typed_data';

class Agency {
  String? id;
  String? name;
  String? image;
  String? login;
  String? password;
  Uint8List? fileBytes; // <—
  String? fileName; // <—
  String? agency;

  Agency({
    this.id,
    this.name,
    this.image,
    this.login,
    this.password,
    this.fileBytes,
    this.fileName,
    this.agency,
  });

  factory Agency.fromJson(Map<String, dynamic> json) => Agency(
    id: json['id'],
    name: json['name'],
    image: json['image'] ?? '',
    login: json['login'],
    password: json['password'],
    fileBytes: json['fileBytes'],
    fileName: json['fileName'],
    agency: json['agency'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'login': login,
    'password': password,
    'fileBytes': fileBytes,
    'fileName': fileName,
    'agency': agency,
  };
}
