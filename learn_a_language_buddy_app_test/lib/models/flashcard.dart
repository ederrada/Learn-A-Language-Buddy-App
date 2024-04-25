//import 'package:cloud_firestore/cloud_firestore.dart';

class Flashcard {
  //final String userId;
  //final String deckId;
  final String flashcardId;
  final String sourceText;
  final String translatedText;
  final DateTime createdAt;

  Flashcard(
      {
      //required this.userId,
      //required this.deckId,
      required this.flashcardId,
      required this.sourceText,
      required this.translatedText,
      required this.createdAt});
}
