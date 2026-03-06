// test/features/translation/domain/usecases/translate_text_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

// IMPORTANT: Change 'vistl' to your actual project name!
import 'package:vistl/core/errors/failures.dart';
import 'package:vistl/features/translation/domain/entities/translation_entity.dart';
import 'package:vistl/features/translation/domain/repositories/translation_repository.dart';
import 'package:vistl/features/translation/domain/usecases/translate_text_usecase.dart';

// 1. Create a Mock for the Repository
class MockTranslationRepository extends Mock implements TranslationRepository {}

void main() {
  late TranslateTextUseCase usecase;
  late MockTranslationRepository mockRepository;

  // setUp runs before EVERY test
  setUp(() {
    mockRepository = MockTranslationRepository();
    usecase = TranslateTextUseCase(mockRepository);
  });

  // Dummy data for testing
  const tOriginalText = 'Hello';
  final tTranslationEntity = TranslationEntity(
    id: '1',
    originalText: 'Hello',
    translatedText: 'สวัสดี',
    createdAt: DateTime(2026, 1, 1),
  );

  group('TranslateTextUseCase', () {
    test(
      'Should return TranslationEntity from the repository when translation is successful',
      () async {
        // Arrange: Tell the mock repository what to return when it is called
        when(
          () => mockRepository.translateText(any()),
        ).thenAnswer((_) async => Right(tTranslationEntity));

        // Act: Call the use case
        final result = await usecase.call(tOriginalText);

        // Assert: Verify the result is what we expect
        expect(result, Right(tTranslationEntity));

        // Verify that the repository method was actually called exactly once with the correct text
        verify(() => mockRepository.translateText(tOriginalText)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'Should return a ServerFailure when the input text is entirely empty',
      () async {
        // Arrange
        const emptyText = '   ';

        // Act
        final result = await usecase.call(emptyText);

        // Assert: The UseCase should catch the empty text BEFORE calling the repository
        expect(
          result,
          const Left(ServerFailure("Text to translate cannot be empty.")),
        );

        // Verify the repository was NEVER called because the validation blocked it
        verifyZeroInteractions(mockRepository);
      },
    );
  });
}