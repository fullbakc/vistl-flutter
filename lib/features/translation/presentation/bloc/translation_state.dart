import '../../domain/entities/translation_entity.dart';

abstract class TranslationState {}

class TranslationInitial extends TranslationState {}

class TranslationLoading extends TranslationState {}

class TranslationSuccess extends TranslationState {
  final TranslationEntity translation;
  TranslationSuccess(this.translation);
}

class TranslationHistoryLoaded extends TranslationState {
  final List<TranslationEntity> history;
  TranslationHistoryLoaded(this.history);
}

class TranslationError extends TranslationState {
  final String message;
  TranslationError(this.message);
}
