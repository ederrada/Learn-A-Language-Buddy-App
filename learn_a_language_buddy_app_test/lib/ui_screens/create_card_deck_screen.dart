import 'package:flutter/material.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_auth_service.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/welcome_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_firestore_service.dart';

class CreateCardDeckScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final FirestoreService db = FirestoreService();
  final Uuid uuid = const Uuid();

  CreateCardDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: AppBar(
            title: const Text('Create Card Deck'),
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
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Deck Title'),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                String title = titleController.text.trim();
                String category = categoryController.text.trim();

                if (title.isEmpty || category.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please enter a title and category.'),
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
                String deckId = uuid.v4();

                // Get current user ID
                String userId = auth.getCurrentUser()?.uid ?? '';

                try {
                  // Create the card deck in Firestore
                  await db.createCardDeck(
                    userId,
                    deckId,
                    title,
                    category,
                    //'English',
                    //Will implement other languages next iteration
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

                  titleController.clear();
                  categoryController.clear();
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
              child: const Text('Save Deck'),
            ),
          ],
        ),
      ),
    );
  }
}
