import 'package:flutter/material.dart';
//TODO: Import necessary packages

class CreateCardDeckScreen extends StatelessWidget {
  const CreateCardDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Card Deck'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Deck Title'),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement logic to save the new card deck
                Navigator.pop(context); // To close the screen after saving
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
