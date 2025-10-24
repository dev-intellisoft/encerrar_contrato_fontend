class Agency {
  String? id;
  String name;
  String image;
  String login;
  String password;

  Agency({
    this.id,
    required this.name,
    required this.image,
    required this.login,
    required this.password,
  });

  factory Agency.fromJson(Map<String, dynamic> json) => Agency(
    id: json['id'],
    name: json['name'],
    image: json['image'] ?? '',
    login: json['login'],
    password: json['password'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'login': login,
    'password': password,
  };
}
