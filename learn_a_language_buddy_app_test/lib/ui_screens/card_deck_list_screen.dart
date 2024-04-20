import 'package:flutter/material.dart';
import 'create_card_deck_screen.dart';
import 'flashcard_list_screen.dart';

class CardDeckListScreen extends StatelessWidget {
  const CardDeckListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Card Decks'),
      ),
      body: ListView.builder(
        itemCount: 5, // TODO: Replace with actual number of decks
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Deck ${index + 1}'),
            subtitle: const Text('10 cards'), // TODO: Replace with deck details
            onTap: () {
              // Navigate to the screen displaying flashcards in this deck
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardListScreen(deckIndex: index),
                ),
              );
            },
          );
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
