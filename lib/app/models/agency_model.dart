// import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart'; // or file_picker

class Agency {
  String? id;
  String? name;
  String? image;
  String? login;
  String? password;
  XFile? file;
  Uint8List? fileBytes; // <—
  String? fileName; // <—

  Agency({
    this.id,
    this.name,
    this.image,
    this.login,
    this.password,
    this.file,
    this.fileBytes,
    this.fileName,
  });

  factory Agency.fromJson(Map<String, dynamic> json) => Agency(
    id: json['id'],
    name: json['name'],
    image: json['image'] ?? '',
    login: json['login'],
    password: json['password'],
    file: json['file'],
    fileBytes: json['fileBytes'],
    fileName: json['fileName'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'login': login,
    'password': password,
    'file': file,
    'fileBytes': fileBytes,
    'fileName': fileName,
  };
}
