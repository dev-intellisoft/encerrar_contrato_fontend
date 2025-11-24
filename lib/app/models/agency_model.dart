import 'dart:io';

class Agency {
  String? id;
  String? name;
  String? image;
  String? login;
  String? password;
  File? file;

  Agency({
    this.id,
    this.name,
    this.image,
    this.login,
    this.password,
    this.file
  });

  factory Agency.fromJson(Map<String, dynamic> json) => Agency(
    id: json['id'],
    name: json['name'],
    image: json['image'] ?? '',
    login: json['login'],
    password: json['password'],
    file: json['file']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'login': login,
    'password': password,
    'file': file
  };
}
