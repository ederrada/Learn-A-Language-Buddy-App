class Flashcard {
  final String userId;
  final String deckId;
  final String flashcardId;
  final String frontText;
  final String backText;

  Flashcard({
    required this.userId,
    required this.deckId,
    required this.flashcardId,
    required this.frontText,
    required this.backText,
  });
}
