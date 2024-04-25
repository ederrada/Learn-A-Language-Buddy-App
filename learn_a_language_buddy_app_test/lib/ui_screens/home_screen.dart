// import 'package:flutter/material.dart';
// import 'package:learn_a_language_buddy_app_test/ui_screens/create_card_deck_screen.dart';
// import 'package:learn_a_language_buddy_app_test/ui_screens/card_deck_list_screen.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CreateCardDeckScreen(),
//                   ),
//                 );
//               },
//               child: Text('Create Flashcards Deck'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CardDeckListScreen(),
//                   ),
//                 );
//               },
//               child: Text('View/Edit Card Decks'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:learn_a_language_buddy_app_test/ui_screens/create_card_deck_screen.dart';
// import 'package:learn_a_language_buddy_app_test/ui_screens/card_deck_list_screen.dart';
// import 'package:learn_a_language_buddy_app_test/models/card_deck.dart'; // Import your CardDeck model

// class HomeScreen extends StatelessWidget {
//   // Dummy list of card decks (replace with actual data from Firestore)
//   final List<CardDeck> cardDecks = [
//     CardDeck(
//       id: '1',
//       title: 'My First Deck',
//       category: 'General',
//       //languageCode: 'en',
//       flashcardCount: 10,
//       createdAt: DateTime.now(),
//     ),
//     CardDeck(
//       id: '2',
//       title: 'Travel Phrases',
//       category: 'Travel',
//       //languageCode: 'es',
//       flashcardCount: 15,
//       createdAt: DateTime.now(),
//     ),
//     // Add more card decks as needed...
//   ];

//   HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CreateCardDeckScreen(),
//                   ),
//                 );
//               },
//               child: const Text('Create Flashcards Deck'),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: cardDecks.length,
//               itemBuilder: (context, index) {
//                 final cardDeck = cardDecks[index];
//                 return GestureDetector(
//                   onTap: () {
//                     // Navigate to view/edit card deck screen
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CardDeckListScreen(cardDeck: cardDeck),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.all(8.0),
//                     child: ListTile(
//                       title: Text(cardDeck.title),
//                       subtitle: Text('Category: ${cardDeck.category} | Flashcards: ${cardDeck.flashcardCount}'),
//                       trailing: const Icon(Icons.arrow_forward_ios),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_a_language_buddy_app_test/models/card_deck.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_auth_service.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_firestore_service.dart'; // Import your FirestoreService
import 'package:learn_a_language_buddy_app_test/ui_screens/create_card_deck_screen.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/flashcard_list_screen.dart';
//import 'package:learn_a_language_buddy_app_test/ui_screens/card_deck_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final FirestoreService db = FirestoreService();
  final AuthService auth = AuthService();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateCardDeckScreen(),
                  ),
                );
              },
              child: const Text('Create Flashcards Deck'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<CardDeck>>(
              stream: db.getCardDecks(auth.getCurrentUser()!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  List<CardDeck>? cardDecks = snapshot.data;
                  if (cardDecks == null || cardDecks.isEmpty) {
                    return const Center(
                      child: Text('No card decks found.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: cardDecks.length,
                    itemBuilder: (context, index) {
                      final cardDeck = cardDecks[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to view/edit card deck screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlashcardListScreen(
                                deckIndex: index,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(cardDeck.title),
                            //subtitle: Text('Category: ${cardDeck.category}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Category: ${cardDeck.category} | Flashcards: ${cardDeck.flashcardCount}'),
                                Text(
                                    'Created: ${DateFormat.yMMMd().format(cardDeck.createdAt)}'),
                              ],
                            ),

                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
