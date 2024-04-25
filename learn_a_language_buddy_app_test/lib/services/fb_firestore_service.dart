import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_a_language_buddy_app_test/models/card_deck.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  //For caching the flashcards translated data to reduce the amount of
  //calls to Google Translate API
  final CollectionReference<Map<String, dynamic>> flashcardsCollection =
      FirebaseFirestore.instance.collection('flashcards');

//User CRUD
  //CREATE: Create a user
  Future<void> createUser(
      String? userId, String? userName, String? userEmail) async {
    try {
      await db.collection('users').doc(userId).set({
        'username': userName,
        'useremail': userEmail,
      });
    } catch (e) {
      print('Error creating a user: $e');
      rethrow;
    }
  }

  //READ: Retrieve a user
  Stream<DocumentSnapshot?> getUserInfoStream(String userId) {
    try {
      return db
          .collection('users')
          .doc(userId)
          .snapshots()
          .map((snapshot) => snapshot);
    } catch (e) {
      print('Error retrieving user information: $e');
      return Stream.value(null);
    }
  }

  //UPDATE: Update a user
  Future<void> updateUser(
      String userId, String userName, String userEmail) async {
    try {
      await db.collection('users').doc(userId).update({
        'username': userName,
        'useremail': userEmail,
      });
    } catch (e) {
      print('Error updating user information: $e');
      rethrow;
    }
  }

  //DELETE: Delete a user
  Future<void> deleteUser(String userId) async {
    try {
      await db.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting the user: $e');
      rethrow;
    }
  }

//Card Deck CRUD
  //CREATE: Create a new card deck for a user
  Future<void> createCardDeck(
      String userId, String deckId, String title, String category) async {
    try {
      await db.collection('users').doc(userId).collection('cardDecks').add({
        'deckId': deckId,
        'title': title,
        'category': category,
        //'language': language,
        //'flashcardCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // await db
      //     .collection('users')
      //     .doc(userId)
      //     .collection('cardDecks')
      //     .doc(deckId)
      //     .update({
      //   'flashcardCount':
      //       FieldValue.increment(1), // Increment flashcard count by 1
      // });
    } catch (e) {
      print('Error creating card deck: $e');
      rethrow;
    }
  }

  //READ: Retrieve all card decks for a user
  Stream<List<CardDeck>> getCardDecks(String userId) {
    return db
        .collection('users')
        .doc(userId)
        .collection('cardDecks')
        .snapshots()
        .map((snapshot) {
      List<CardDeck> cardDecks = [];
      for (var doc in snapshot.docs) {
        var data = doc.data();
        String deckId = doc.id;
        String title = data['title'] ?? '';
        String category = data['category'] ?? '';
        int flashcardCount = snapshot.size;

        // Create a CardDeck object and add it to the list
        CardDeck cardDeck = CardDeck(
          id: deckId,
          title: title,
          category: category,
          flashcardCount: flashcardCount,
          createdAt: DateTime.timestamp(),
          //createdAt: FieldValue.serverTimestamp(),
        );
        cardDecks.add(cardDeck);
      }
      return cardDecks;
    });
  }

//   Stream<List<CardDeck>> getCardDecks() {
//   return db
//       .collection('users') // Assuming card decks are stored under 'users' collection
//       .snapshots()
//       .map((snapshot) {
//     List<CardDeck> cardDecks = [];
//     for (var doc in snapshot.docs) {
//       var data = doc.data();
//       // Extract necessary fields from the document data
//       String deckId = doc.id;
//       String title = data['title'] ?? '';
//       String category = data['category'] ?? '';
//       // String language = data['language'] ?? '';
//       // int flashcardCount = data['flashcardCount'] ?? 0;

//       // Create a CardDeck object and add it to the list
//       CardDeck cardDeck = CardDeck(
//         id: deckId,
//         title: title,
//         category: category,
//         // language: language,
//         // flashcardCount: flashcardCount,
//         createdAt: FieldValue.serverTimestamp(), // Use DateTime.now() as a placeholder for createdAt
//       );
//       cardDecks.add(cardDeck);
//     }
//     return cardDecks;
//   });
// }

  //UPDATE: Update a card deck information
  Future<void> updateCardDeck(String userId, String deckId, String title,
      String category, String language) async {
    try {
      await db
          .collection('users')
          .doc(userId)
          .collection('cardDecks')
          .doc(deckId)
          .update({
        'title': title,
        'category': category,
        'language': language,
      });
    } catch (e) {
      print('Error updating card deck: $e');
      rethrow;
    }
  }

  //DELETE: Delete a card deck
  Future<void> deleteCardDeck(String deckId) async {
    try {
      await db.collection('cardDecks').doc(deckId).delete();
    } catch (e) {
      print('Error deleting card deck: $e');
      rethrow;
    }
  }

  //TODO: Implement other CRUD methods for flashcards within a deck
  //For caching and fetching translated flashcards
  //Method to cache translated flashcards
  Future<void> cacheFlashcardData(
      String sourceText, String translatedText) async {
    await flashcardsCollection.doc().set({
      'sourceText': sourceText,
      'translatedText': translatedText,
    });
  }

  //Method to retrieve translated flashcards
  Stream<List<Map<String, dynamic>>> getFlashcardData() {
    return flashcardsCollection.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

//Flashcards CRUD
  //CREATE: add a new flashcard to a specific card deck
  Future<void> addFlashcardToDeck(String userId, String deckId,
      String flashcardId, String sourceText, String translatedText) async {
    try {
      // Add the flashcard to the deck
      await db
          .collection('users')
          .doc(userId)
          .collection('cardDecks')
          .doc(deckId)
          .collection('flashcards')
          .add({
        'flashcardId': flashcardId,
        'sourceText': sourceText,
        'translatedText': translatedText,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update the flashcard count for the deck
      await db
          .collection('users')
          .doc(userId)
          .collection('cardDecks')
          .doc(deckId)
          .update({
        'flashcardCount':
            FieldValue.increment(1), // Increment flashcard count by 1
      });
    } catch (e) {
      print('Error adding flashcard to deck: $e');
      rethrow;
    }
  }

//Method to update a user's flashcard count inside a deck
  // Future<void> updateFlashcardCount(String userId, String deckId) async {
  //   try {
  //     // Fetch the current count of flashcards in the deck
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await db
  //         .collection('users')
  //         .doc(userId)
  //         .collection('cardDecks')
  //         .doc(deckId)
  //         .collection('flashcards')
  //         .get();

  //     int flashcardCount = snapshot.size;

  //     // Update the flashcard count for the deck
  //     await db
  //         .collection('users')
  //         .doc(userId)
  //         .collection('cardDecks')
  //         .doc(deckId)
  //         .update({
  //       'flashcardCount': flashcardCount,
  //     });
  //   } catch (e) {
  //     print('Error updating flashcard count: $e');
  //     rethrow;
  //   }
  // }

  //READ: Retrieve all flashcards for a specific card deck
  Stream<List<DocumentSnapshot>> getFlashcardsForDeck(
      String userId, String deckId) {
    return db
        .collection('users')
        .doc(userId)
        .collection('cardDecks')
        .doc(deckId)
        .collection('flashcards')
        .snapshots()
        .map((snapshot) => snapshot.docs.toList());
  }

  //UPDATE: Update a flashcard within a specific card deck
  Future<void> updateFlashcardInDeck(String userId, String deckId,
      String flashcardId, Map<String, dynamic> updatedData) async {
    try {
      await db
          .collection('users')
          .doc(userId)
          .collection('cardDecks')
          .doc(deckId)
          .collection('flashcards')
          .doc(flashcardId)
          .update(updatedData);
    } catch (e) {
      print('Error updating flashcard: $e');
      rethrow;
    }
  }

  //DELETE: Delete a flashcard from a specific card deck
  Future<void> deleteFlashcardFromDeck(
      String userId, String deckId, String flashcardId) async {
    try {
      await db
          .collection('users')
          .doc(userId)
          .collection('cardDecks')
          .doc(deckId)
          .collection('flashcards')
          .doc(flashcardId)
          .delete();

      //Update the flashcard count for the deck (decrement by 1)
      await db
          .collection('users')
          .doc(userId)
          .collection('cardDecks')
          .doc(deckId)
          .update({
        'flashcardCount': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error deleting flashcard: $e');
      rethrow;
    }
  }
}
