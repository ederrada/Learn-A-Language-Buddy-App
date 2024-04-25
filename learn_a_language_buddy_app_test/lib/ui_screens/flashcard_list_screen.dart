// import 'package:flutter/material.dart';
// //TODO: Import necessary packages

// class FlashcardListScreen extends StatelessWidget {
//   final int deckIndex;

//   FlashcardListScreen({required this.deckIndex});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flashcards'),
//       ),
//       body: ListView.builder(
//         itemCount: 10, // TODO: Replace with actual number of flashcards
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text('Flashcard ${index + 1}'),
//             subtitle: const Text('Front: English | Back: Spanish'), // Simulated content
//             onTap: () {
//               // TODO: Implement card detail view or edit functionality
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // TODO: Implement logic to add a new flashcard to this deck
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:learn_a_language_buddy_app_test/models/card_deck.dart';
// import 'package:learn_a_language_buddy_app_test/ui_screens/create_flashcard_screen.dart';

// class FlashcardListScreen extends StatelessWidget {
//   final CardDeck cardDeck;

//   const FlashcardListScreen({super.key, required this.cardDeck});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flashcards for ${cardDeck.title}'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Navigate to CreateFlashcardScreen
//             CardDeck myCardDeck = CardDeck(
//                 id: cardDeck.id,
//                 title: cardDeck.title,
//                 category: cardDeck.category,
//                 flashcardCount: cardDeck.flashcardCount,
//                 createdAt: cardDeck.createdAt);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     CreateFlashcardScreen(cardDeck: myCardDeck),
//               ),
//             );
//           },
//           child: const Text('Create Flashcard'),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:learn_a_language_buddy_app_test/models/card_deck.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/create_flashcard_screen.dart';

class FlashcardListScreen extends StatelessWidget {
  final CardDeck cardDeck;

  const FlashcardListScreen({Key? key, required this.cardDeck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards for ${cardDeck.title}'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to CreateFlashcardScreen with existing cardDeck
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateFlashcardScreen(cardDeck: cardDeck),
              ),
            );
          },
          child: const Text('Create Flashcard'),
        ),
      ),
    );
  }
}

