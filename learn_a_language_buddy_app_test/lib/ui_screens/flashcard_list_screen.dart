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
//import 'package:intl/intl.dart';
import 'package:learn_a_language_buddy_app_test/models/card_deck.dart';
import 'package:learn_a_language_buddy_app_test/models/flashcard.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_auth_service.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/create_flashcard_screen.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_firestore_service.dart';

class FlashcardListScreen extends StatelessWidget {
  final CardDeck cardDeck;
  final FirestoreService db = FirestoreService();
  final AuthService auth = AuthService();

  FlashcardListScreen({Key? key, required this.cardDeck}) : super(key: key);

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
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateFlashcardScreen(
                      cardDeck: cardDeck,
                    ),
                  ),
                );
              },
              child: const Text('Create Flashcards Deck'),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Flashcard>>(
              stream: db.getFlashcardsForDeck(
                  auth.getCurrentUser()!.uid, cardDeck.id),
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
                  List<Flashcard>? flashcards = snapshot.data;
                  if (flashcards == null || flashcards.isEmpty) {
                    return const Center(
                      child: Text('No card decks found.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: flashcards.length,
                    itemBuilder: (context, index) {
                      return FlashcardTile(
                        flashcard: flashcards[index],
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

class FlashcardTile extends StatefulWidget {
  final Flashcard flashcard;

  const FlashcardTile({Key? key, required this.flashcard}) : super(key: key);

  @override
  FlashcardTileState createState() => FlashcardTileState();
}

class FlashcardTileState extends State<FlashcardTile>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> frontRotation;
  late Animation<double> backRotation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    frontRotation = Tween<double>(
      begin: 0,
      end: -1 * 3.14159, // 180 degrees in radians
    ).animate(controller);

    backRotation = Tween<double>(
      begin: 3.14159, // 180 degrees in radians
      end: 0,
    ).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.isCompleted ? controller.reverse() : controller.forward();
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(controller.value > 0.5
                  ? backRotation.value
                  : frontRotation.value),
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.all(8),
              child: Container(
                height: 200, // Fixed height for the card
                padding: const EdgeInsets.all(16),
                alignment: Alignment
                    .center, // Center the text horizontally and vertically
                child: Text(
                  controller.value > 0.5
                      ? widget.flashcard.translatedText
                      : widget.flashcard.sourceText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}