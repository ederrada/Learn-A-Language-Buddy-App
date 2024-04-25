import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_a_language_buddy_app_test/models/card_deck.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_auth_service.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_firestore_service.dart';
import 'package:uuid/uuid.dart';
import 'package:translator/translator.dart';

class CreateFlashcardScreen extends StatefulWidget {
  //final String userId;
  //final String deckId;
  final CardDeck cardDeck;

  const CreateFlashcardScreen(
      {Key? key,
      //required this.userId,
      //required this.deckId,
      required this.cardDeck})
      : super(key: key);

  @override
  CreateFlashcardScreenState createState() => CreateFlashcardScreenState();
}

class CreateFlashcardScreenState extends State<CreateFlashcardScreen> {
  TextEditingController frontTextController = TextEditingController();
  String translatedText = '';


  final Uuid uuid = const Uuid();
  final FirestoreService db = FirestoreService();
  final AuthService auth = AuthService();

  void translateText(String sourceText) async {
    final translation = await sourceText.translate(to: 'es');

    setState(() {
      translatedText = 'Translated: ${translation.text}';
    });
  }

  @override
  Widget build(BuildContext context) {
    CardDeck myCardDeck = widget.cardDeck;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: frontTextController,
              decoration:
                  const InputDecoration(labelText: 'Enter text to translate'),
              onChanged: (value) {
                translateText(value);
              },
            ),
            const SizedBox(height: 20.0),
            Text(
              translatedText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Get the entered source text
                String sourceText = frontTextController.text.trim();

                if (sourceText.isEmpty) {
                  // Show error message if title or category is empty
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please enter a word or phrase.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                // Generate a unique ID for the card deck
                String flashcardId = uuid.v4();

                // Get current user ID
                //String userId = auth.getCurrentUser()?.uid ?? '';
                String userId = FirebaseAuth.instance.currentUser!.uid;

                //Grab the current card deck ID
                String deckId = myCardDeck.id;
                
                try {
                  // Create the card deck in Firestore
                  await db.addFlashcardToDeck(userId, deckId, flashcardId, translatedText, sourceText);

                  if (!context.mounted) {
                    return;
                  }

                  // Show success message
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Success'),
                      content: const Text('Card deck created successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close success dialog
                            Navigator.pop(
                                context); // Navigate back to previous screen (HomeScreen)
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );

                  // Clear these fields after successful creation
                  frontTextController.clear();
                } catch (e) {
                  // Show error message if creation fails
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: Text('Failed to create card deck. $e'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Save Flashcard'),
            ),
          ],
        ),
      ),
    );
  }
}


 // void saveFlashcard() async {
  //   String frontText = frontTextController.text.trim();
  //   //String translatedText = _translatedTextController.text.trim();

  //   if (frontText.isEmpty) {
  //     // Show an error message if fields are empty
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please enter both texts')),
  //     );
  //     return;
  //   }

  //   try {
  //     // Save flashcard to Firestore using the FirestoreService
  //     await FirestoreService().addFlashcardToDeck(
  //       widget.userId,
  //       widget.deckId,
  //       frontText,
  //       translatedText,
  //     );

  //     // Show a success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Flashcard saved successfully')),
  //     );

  //     // Clear text fields after saving
  //     _frontTextController.clear();
  //   } catch (e) {
  //     // Show an error message if save operation fails
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to save flashcard')),
  //     );
  //   }
  // }