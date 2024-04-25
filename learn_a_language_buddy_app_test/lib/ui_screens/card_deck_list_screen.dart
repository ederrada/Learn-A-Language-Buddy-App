import 'package:flutter/material.dart';
import 'package:learn_a_language_buddy_app_test/models/card_deck.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_firestore_service.dart';
import 'create_card_deck_screen.dart';
import 'flashcard_list_screen.dart';

class CardDeckListScreen extends StatelessWidget {
  final FirestoreService db = FirestoreService();
  final String userId;

  CardDeckListScreen(
      // {super.key, required CardDeck cardDeck, required this.userId});
      {super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Card Decks'),
      ),
      body: StreamBuilder<List<CardDeck>>(
        stream: db.getCardDecks(userId), // Use stream to listen for changes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No card decks found.'));
          } else {
            List<CardDeck> cardDecks = snapshot.data!;
            return ListView.builder(
              itemCount: cardDecks.length,
              itemBuilder: (context, index) {
                final cardDeck = cardDecks[index];
                return ListTile(
                  title: Text(cardDeck.title),
                  //subtitle: Text('${cardDeck.flashcardCount} cards'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FlashcardListScreen(cardDeck: cardDeck),

                        //FlashcardListScreen(deckId: cardDeck.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen to create a new card deck
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCardDeckScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:learn_a_language_buddy_app_test/models/card_deck.dart';
// import 'create_card_deck_screen.dart';
// import 'flashcard_list_screen.dart';

// class CardDeckListScreen extends StatelessWidget {
//   const CardDeckListScreen({super.key, required CardDeck cardDeck});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Card Decks'),
//       ),
//       body: ListView.builder(
//         itemCount: 5, // TODO: Replace with actual number of decks
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text('Deck ${index + 1}'),
//             subtitle: const Text('10 cards'), // TODO: Replace with deck details
//             onTap: () {
//               // Navigate to the screen displaying flashcards in this deck
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FlashcardListScreen(deckIndex: index),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to the screen to create a new card deck
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CreateCardDeckScreen(),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
