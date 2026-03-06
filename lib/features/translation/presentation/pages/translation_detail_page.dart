// lib/features/translation/presentation/pages/translation_detail_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/translation_entity.dart';

@RoutePage()
class TranslationDetailPage extends StatelessWidget {
  final TranslationEntity translation;

  const TranslationDetailPage({super.key, required this.translation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translation Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Original:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(translation.originalText),
            const SizedBox(height: 20),
            const Text(
              'Translated:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            // Explicit Animation Requirement (Hero)
            Hero(
              tag: 'translation_${translation.id}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  translation.translatedText,
                  style: const TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
