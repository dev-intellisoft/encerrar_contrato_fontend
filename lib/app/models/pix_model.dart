import 'dart:convert';

class PIX {
  final bool success;
  final String encodedImage;
  final String payload;
  final DateTime? expirationDate;
  final String description;

  PIX({
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
      success: json['success'] as bool? ?? false,
      encodedImage: json['encodedImage'] as String? ?? '',
      payload: json['payload'] as String? ?? '',
      expirationDate: parsedDate,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
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
