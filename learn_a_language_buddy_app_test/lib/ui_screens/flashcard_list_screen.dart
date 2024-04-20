import 'package:flutter/material.dart';
//TODO: Import necessary packages

class FlashcardListScreen extends StatelessWidget {
  final int deckIndex;

  FlashcardListScreen({required this.deckIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
      ),
      body: ListView.builder(
        itemCount: 10, // TODO: Replace with actual number of flashcards
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Flashcard ${index + 1}'),
            subtitle: const Text('Front: English | Back: Spanish'), // Simulated content
            onTap: () {
              // TODO: Implement card detail view or edit functionality
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement logic to add a new flashcard to this deck
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
