import 'package:flutter/material.dart';
import '../utils/api_url.dart';

class AgencyLogo extends StatelessWidget {
  final String imagePath;
  const AgencyLogo({super.key, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    final normalizedPath = imagePath.trim();
    final logoUrl = resolveAssetUrl(normalizedPath);
    if (normalizedPath.isEmpty) {
      return const SizedBox(
        width: 40,
        height: 40,
        child: Icon(
          Icons.image_not_supported,
          size: 40,
          color: Colors.grey,
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.network(
        logoUrl,
        key: ValueKey(logoUrl),
        fit: BoxFit.cover,
        gaplessPlayback: true,

        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },

        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.image_not_supported,
            size: 40,
            color: Colors.grey,
          );
        },
      ),
    );
  }
}
