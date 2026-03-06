// lib/features/translation/domain/entities/translation_entity.dart
import 'package:equatable/equatable.dart';

class TranslationEntity extends Equatable {
  final String id;
  final String originalText;
  final String translatedText;
  final DateTime createdAt;

  const TranslationEntity({
    required this.id,
    required this.originalText,
    required this.translatedText,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, originalText, translatedText, createdAt];
}
