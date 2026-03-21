import 'dart:convert';

class PIX {
  final bool success;
  final bool? paid;
  final String encodedImage;
  final String payload;
  final DateTime? expirationDate;
  final String description;

  PIX({
    required this.paid,
    required this.success,
    required this.encodedImage,
    required this.payload,
    this.expirationDate,
    required this.description,
  });

  PIX copyWith({
    bool? success,
    String? encodedImage,
    String? payload,
    DateTime? expirationDate,
    String? description,
  }) {
    return PIX(
      paid: paid ?? this.paid,
      success: success ?? this.success,
      encodedImage: encodedImage ?? this.encodedImage,
      payload: payload ?? this.payload,
      expirationDate: expirationDate ?? this.expirationDate,
      description: description ?? this.description,
    );
  }

  factory PIX.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    final raw = json['expirationDate'];
    if (raw != null && raw is String && raw.isNotEmpty) {
      try {
        parsedDate = DateTime.parse(raw);
      } catch (_) {
        parsedDate = null;
      }
    }

    return PIX(
      paid: json['paid'] as bool? ?? false,
      success: json['success'] as bool? ?? false,
      encodedImage: json['encodedImage'] as String? ?? '',
      payload: json['payload'] as String? ?? '',
      expirationDate: parsedDate,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'paid': paid,
    'success': success,
    'encodedImage': encodedImage,
    'payload': payload,
    'expirationDate': expirationDate?.toUtc().toIso8601String() ?? '',
    'description': description,
  };

  @override
  String toString() {
    return 'PixResponse(success: $success, payload: ${payload.substring(0, payload.length > 40 ? 40 : payload.length)}..., expirationDate: $expirationDate)';
  }
}

class PIXResponse {
  bool? paid;
  bool? success;
  String? encodedImage;
  String? payload;
  DateTime? expirationDate;
  String? description;
  double? value;

  PIXResponse({
    this.paid,
    this.success,
    this.encodedImage,
    this.payload,
    this.expirationDate,
    this.description,
    this.value,
  });

  PIXResponse copyWith({
    bool? success,
    String? encodedImage,
    String? payload,
    DateTime? expirationDate,
    String? description,
    double? value,
  }) {
    return PIXResponse(
      paid: paid ?? this.paid,
      success: success ?? this.success,
      encodedImage: encodedImage ?? this.encodedImage,
      payload: payload ?? this.payload,
      expirationDate: expirationDate ?? this.expirationDate,
      description: description ?? this.description,
      value: value ?? this.value,
    );
  }

  factory PIXResponse.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    final raw = json['expirationDate'];
    if (raw != null && raw is String && raw.isNotEmpty) {
      try {
        parsedDate = DateTime.parse(raw);
      } catch (_) {
        parsedDate = null;
      }
    }

    return PIXResponse(
      success: json['success'] as bool? ?? false,
      encodedImage: json['encodedImage'] as String? ?? '',
      payload: json['payload'] as String? ?? '',
      expirationDate: parsedDate,
      description: json['description'] as String? ?? '',
      value: json['value'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'paid': paid,
    'success': success,
    'encodedImage': encodedImage,
    'payload': payload,
    'expirationDate': expirationDate?.toUtc().toIso8601String() ?? '',
    'description': description,
    'value': value,
  };
}
