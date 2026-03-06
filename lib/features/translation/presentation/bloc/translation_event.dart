abstract class TranslationEvent {}

class ExtractAndTranslateTextEvent extends TranslationEvent {
  final String imagePath;
  ExtractAndTranslateTextEvent(this.imagePath);
}

class LoadHistoryEvent extends TranslationEvent {}
