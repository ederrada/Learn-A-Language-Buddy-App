import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Method to create a new card deck
  Future<void> createCardDeck(String userId, String title, String category) async {
    try {
      await db.collection('cardDecks').add({
        'userId': userId,
        'title': title,
        'category': category,
        // Add more fields as needed
      });
    } catch (e) {
      print('Error creating card deck: $e');
      rethrow;
    }
  }

  // Method to delete a card deck
  Future<void> deleteCardDeck(String deckId) async {
    try {
      await db.collection('cardDecks').doc(deckId).delete();
    } catch (e) {
      print('Error deleting card deck: $e');
      rethrow;
    }
  }

  //TODO: Implement other CRUD methods for flashcards within a deck


}
