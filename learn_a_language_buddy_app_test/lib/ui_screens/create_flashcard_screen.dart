import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_a_language_buddy_app_test/models/card_deck.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_auth_service.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_firestore_service.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/welcome_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:translator/translator.dart';

class CreateFlashcardScreen extends StatefulWidget {
  final CardDeck cardDeck;

  const CreateFlashcardScreen({Key? key, required this.cardDeck})
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
    final translation = await sourceText.translate(to: 'fr');

    setState(() {
      translatedText = translation.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    CardDeck myCardDeck = widget.cardDeck;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: AppBar(
            title: const Text('Create Flashcard'),
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20.0),
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
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Get the entered source text
                String sourceText = frontTextController.text.trim();

                if (sourceText.isEmpty) {
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
                  await db.addFlashcardToDeck(
                    userId,
                    deckId,
                    flashcardId,
                    sourceText,
                    translatedText,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Success'),
                      content: const Text('Card deck created successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );

                  // Clear fields after successful creation
                  frontTextController.clear();
                } catch (e) {
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
