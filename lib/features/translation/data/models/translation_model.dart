// lib/features/translation/data/models/translation_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/translation_entity.dart';

part 'translation_model.freezed.dart';
part 'translation_model.g.dart';

@freezed
abstract class TranslationModel with _$TranslationModel {
  const TranslationModel._();

  const factory TranslationModel({
    required String id,
    required String originalText,
    required String translatedText,
    required DateTime createdAt,
  }) = _TranslationModel;

  factory TranslationModel.fromJson(Map<String, dynamic> json) =>
      _$TranslationModelFromJson(json);

  // 👉 ADD THIS: Mapper method to convert Model -> Entity
  TranslationEntity toEntity() {
    return TranslationEntity(
      id: id,
      originalText: originalText,
      translatedText: translatedText,
      createdAt: createdAt,
    );
  }

  // 👉 ADD THIS: Mapper method to convert Entity -> Model (useful for saving to DB)
  factory TranslationModel.fromEntity(TranslationEntity entity) {
    return TranslationModel(
      id: entity.id,
      originalText: entity.originalText,
      translatedText: entity.translatedText,
      createdAt: entity.createdAt,
    );
  }
}
