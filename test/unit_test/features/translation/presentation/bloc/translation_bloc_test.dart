// test/features/translation/presentation/bloc/translation_bloc_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

// IMPORTANT: Change 'vistl' to your actual project name!
import 'package:vistl/core/errors/failures.dart';
import 'package:vistl/features/translation/domain/entities/translation_entity.dart';
import 'package:vistl/features/translation/domain/repositories/translation_repository.dart';
import 'package:vistl/features/translation/domain/usecases/translate_text_usecase.dart';
import 'package:vistl/features/translation/presentation/bloc/translation_bloc.dart';
import 'package:vistl/features/translation/presentation/bloc/translation_event.dart';
import 'package:vistl/features/translation/presentation/bloc/translation_state.dart';

// 1. Create Mocks for the Dependencies
class MockTranslateTextUseCase extends Mock implements TranslateTextUseCase {}

class MockTranslationRepository extends Mock implements TranslationRepository {}

class FakeTranslationEntity extends Fake implements TranslationEntity {}

void main() {

  setUpAll(() {
    registerFallbackValue(FakeTranslationEntity());
  });

  late TranslationBloc bloc;
  late MockTranslateTextUseCase mockTranslateTextUseCase;
  late MockTranslationRepository mockTranslationRepository;

  // setUp runs before every single test to give us a fresh BLoC
  setUp(() {
    mockTranslateTextUseCase = MockTranslateTextUseCase();
    mockTranslationRepository = MockTranslationRepository();

    bloc = TranslationBloc(
      translateTextUseCase: mockTranslateTextUseCase,
      repository: mockTranslationRepository,
    );
  });

  // tearDown runs after every test to close the stream and prevent memory leaks
  tearDown(() {
    bloc.close();
  });

  // Dummy data for our tests
  final tTranslationEntity = TranslationEntity(
    id: '1',
    originalText: 'Hello',
    translatedText: 'สวัสดี',
    createdAt: DateTime(2026, 1, 1),
  );

  group('LoadHistoryEvent', () {
    final tHistoryList = [tTranslationEntity];

    test(
      'Should emit [TranslationLoading, TranslationHistoryLoaded] when data is fetched successfully',
      () async {
        // 1. Arrange: Tell the mock repository what to return
        when(
          () => mockTranslationRepository.getTranslationHistory(),
        ).thenAnswer((_) async => Right(tHistoryList));

        // 2. Assert Later: Because BLoC uses streams, we must set up what we EXPECT to happen
        // BEFORE we actually trigger the event.
        final expectedStates = [
          isA<TranslationLoading>(),
          isA<TranslationHistoryLoaded>(),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        // 3. Act: Fire the event
        bloc.add(LoadHistoryEvent());
      },
    );

    test(
      'Should emit [TranslationLoading, TranslationError] when fetching history fails',
      () async {
        // 1. Arrange: Simulate a database crash
        when(
          () => mockTranslationRepository.getTranslationHistory(),
        ).thenAnswer(
          (_) async => const Left(CacheFailure('Failed to load DB')),
        );

        // 2. Assert Later: We expect it to load, then immediately fail
        final expectedStates = [
          isA<TranslationLoading>(),
          isA<TranslationError>(),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        // 3. Act
        bloc.add(LoadHistoryEvent());
      },
    );
  });

  group('ExtractAndTranslateTextEvent', () {
    const tImagePath = '/fake/path/image.png';
    const tExtractedText = 'Hello';

    test(
      'Should emit [Loading, Success] and save to DB when extraction and translation succeed',
      () async {
        // 1. Arrange: We have to mock 3 different steps for this event!
        // Step A: ML Kit extracts text
        when(
          () => mockTranslationRepository.extractTextFromImage(any()),
        ).thenAnswer((_) async => const Right(tExtractedText));

        // Step B: Gemini translates text
        when(
          () => mockTranslateTextUseCase.call(any()),
        ).thenAnswer((_) async => Right(tTranslationEntity));

        // Step C: Save to database
        when(
          () => mockTranslationRepository.saveTranslation(any()),
        ).thenAnswer((_) async => const Right(null));

        // 2. Assert Later
        final expectedStates = [
          isA<TranslationLoading>(),
          isA<TranslationSuccess>(),
        ];
        expectLater(bloc.stream, emitsInOrder(expectedStates));

        // 3. Act
        bloc.add(ExtractAndTranslateTextEvent(tImagePath));
      },
    );
  });
}