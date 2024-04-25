class Flashcard {
  final String flashcardId;
  final String sourceText;
  final String translatedText;
  final DateTime createdAt;

  Flashcard(
      {
      required this.flashcardId,
      required this.sourceText,
      required this.translatedText,
      required this.createdAt});
}
