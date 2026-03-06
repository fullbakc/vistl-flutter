// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/translate_text_usecase.dart';
import '../../domain/repositories/translation_repository.dart';
import 'translation_event.dart';
import 'translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  final TranslateTextUseCase translateTextUseCase;
  final TranslationRepository
  repository; // Added to fetch history & extract text

  TranslationBloc({
    required this.translateTextUseCase,
    required this.repository,
  }) : super(TranslationInitial()) {
    on<ExtractAndTranslateTextEvent>((event, emit) async {
      emit(TranslationLoading());

      // 1. Extract text using ML Kit
      print("DEBUG: Starting Extraction...");
      final extractionResult = await repository.extractTextFromImage(
        event.imagePath,
      );

      await extractionResult.fold(
        (failure) async => emit(TranslationError(failure.message)),
        (extractedText) async {
          // 2. Translate text using Gemini
          final translationResult = await translateTextUseCase.call(
            extractedText,
          );
          print("DEBUG: Text Extracted: $extractedText");
          translationResult.fold(
            (failure) => emit(TranslationError(failure.message)),
            (translation) {
              // 3. Save to local DB (Offline support)
              print("DEBUG: Saving translation: $translation");
              repository.saveTranslation(translation);
              emit(TranslationSuccess(translation));
            },
          );
        },
      );
    });

    on<LoadHistoryEvent>((event, emit) async {
      emit(TranslationLoading());
      final historyResult = await repository.getTranslationHistory();

      historyResult.fold(
        (failure) => emit(TranslationError(failure.message)),
        (history) => emit(TranslationHistoryLoaded(history)),
      );
    });
  }
}
