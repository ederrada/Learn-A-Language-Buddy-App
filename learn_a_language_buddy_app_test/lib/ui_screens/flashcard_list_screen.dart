import 'package:flutter/material.dart';
import 'package:learn_a_language_buddy_app_test/models/card_deck.dart';
import 'package:learn_a_language_buddy_app_test/models/flashcard.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_auth_service.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/create_flashcard_screen.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_firestore_service.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/welcome_screen.dart';

class FlashcardListScreen extends StatelessWidget {
  final CardDeck cardDeck;
  final FirestoreService db = FirestoreService();
  final AuthService auth = AuthService();

  FlashcardListScreen({Key? key, required this.cardDeck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? userName = auth.getCurrentUser()!.displayName;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: AppBar(
            title: Text('$userName\'s Flashcards List'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
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
              child: const Text(
                'Create Flashcards',
                style: TextStyle(fontSize: 18.0),
              ),
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
                      child: Text(
                        'No flashcards found.\nClick on \'Create\' to add a new card.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: flashcards.length,
                    itemBuilder: (context, index) {
                      final flashcard = flashcards[index];
                      return Dismissible(
                        key: Key(flashcard.flashcardId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        onDismissed: (direction) {
                          db.deleteFlashcardFromDeck(
                            auth.getCurrentUser()!.uid,
                            cardDeck.id,
                            flashcard.flashcardId,
                          );
                        },
                        child: FlashcardTile(
                          flashcard: flashcard,
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

  //NOTE: I give credit to whomever built this code.
  //I did not code this portion entirely myself.
  //Thank you to person who built this snippet.
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
                height: 200, // Fixes height for the card
                padding: const EdgeInsets.all(16),
                alignment: Alignment
                    .center, // Centers the text horizontally and vertically
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
