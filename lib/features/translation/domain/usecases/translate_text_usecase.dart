// lib/features/translation/domain/usecases/translate_text_usecase.dart
import 'package:dartz/dartz.dart';
import '/../core/errors/failures.dart';
import '../entities/translation_entity.dart';
import '../repositories/translation_repository.dart';

class TranslateTextUseCase {
  final TranslationRepository repository;

  // The repository will be injected here later using get_it
  TranslateTextUseCase(this.repository);

  Future<Either<Failure, TranslationEntity>> call(String text) async {
    // Basic validation before even hitting the API
    if (text.trim().isEmpty) {
      return const Left(ServerFailure("Text to translate cannot be empty."));
    }

    // Call the repository to do the actual translation
    return await repository.translateText(text);
  }
}
