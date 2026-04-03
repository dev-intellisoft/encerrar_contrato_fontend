import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

bool _isLocalHost(String host) {
  final normalized = host.trim().toLowerCase();
  return normalized == 'localhost' || normalized == '127.0.0.1';
}

String resolveApiBaseUrl() {
  final configured = (dotenv.env['API_URL'] ?? '').trim();

  if (configured.isNotEmpty) {
    if (kIsWeb) {
      final current = Uri.base;
      final configuredUri = Uri.tryParse(configured);
      final configuredIsLocal = configuredUri != null
          ? _isLocalHost(configuredUri.host)
          : configured.contains('localhost') || configured.contains('127.0.0.1');
      final currentIsHttp = current.scheme == 'http' || current.scheme == 'https';
      final currentIsLocal = _isLocalHost(current.host);

      // In deployed web builds we prefer the current origin over a stale localhost env.
      if (configuredIsLocal && currentIsHttp && !currentIsLocal) {
        return current.origin;
      }
    }

    return configured.replaceFirst(RegExp(r'\/+$'), '');
  }

  if (kIsWeb) {
    final current = Uri.base;
    if (current.scheme == 'http' || current.scheme == 'https') {
      return current.origin;
    }
  }

  return '';
}

String resolveAssetUrl(String imagePath) {
  final normalizedPath = imagePath.trim();
  if (normalizedPath.isEmpty) return '';

  if (normalizedPath.startsWith('http://') || normalizedPath.startsWith('https://')) {
    return normalizedPath;
  }

  final baseUrl = resolveApiBaseUrl();
  if (baseUrl.isEmpty) {
    return normalizedPath;
  }

  if (normalizedPath.startsWith('/')) {
    return '$baseUrl$normalizedPath';
  }

  return '$baseUrl/$normalizedPath';
}
