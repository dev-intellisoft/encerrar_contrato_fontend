import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class AgencyLogo extends StatelessWidget {
  final String imagePath;
  const AgencyLogo({super.key, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    final normalizedPath = imagePath.trim();
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

    final path = normalizedPath.startsWith('/')
        ? normalizedPath
        : '/$normalizedPath';

    return Container(
      width: 40,
      height: 40,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.network(
        '${dotenv.env['API_URL']}$path',
        key: ValueKey(path),
        fit: BoxFit.cover,

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
