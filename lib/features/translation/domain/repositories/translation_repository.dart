// lib/features/translation/domain/repositories/translation_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/translation_entity.dart';

abstract class TranslationRepository {
  /// Extracts text from a captured image using Google ML Kit
  Future<Either<Failure, String>> extractTextFromImage(String imagePath);

  /// Sends the extracted text to the LLM (Gemini) for translation
  Future<Either<Failure, TranslationEntity>> translateText(String text);

  /// Saves the translation to the local database for offline viewing
  Future<Either<Failure, void>> saveTranslation(TranslationEntity translation);

  /// Fetches translation history from the local database
  Future<Either<Failure, List<TranslationEntity>>> getTranslationHistory();
}
