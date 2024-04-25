//import 'package:cloud_firestore/cloud_firestore.dart';

class CardDeck {
  final String id;
  final String title;
  final String category;
  //final String languageCode;
  final int flashcardCount;
  final DateTime createdAt;

  CardDeck({
    required this.id,
    required this.title,
    required this.category,
    //required this.languageCode,
    required this.flashcardCount,
    required this.createdAt,
  });
}

// class Flashcard {
//   final String id;
//   final String frontText;
//   final String backText;

//   Flashcard({
//     required this.id,
//     required this.frontText,
//     required this.backText,
//   });
// }
