import 'package:flutter/material.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_auth_service.dart';
import 'package:uuid/uuid.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_firestore_service.dart';

class CreateCardDeckScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController =
      TextEditingController(); // Controller for category
  final FirestoreService db = FirestoreService();
  final Uuid uuid = const Uuid();

  CreateCardDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Card Deck'),
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
              controller: categoryController, // Use categoryController
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Get the entered title and category
                String title = titleController.text.trim();
                String category =
                    categoryController.text.trim(); // Get category

                if (title.isEmpty || category.isEmpty) {
                  // Show error message if title or category is empty
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
                  );

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
                  titleController.clear();
                  categoryController.clear();
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
              child: const Text('Create New Deck'),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:learn_a_language_buddy_app_test/services/fb_firestore_service.dart';
// //TODO: Import necessary packages

// class CreateCardDeckScreen extends StatelessWidget {
//   final FirestoreService firestoreService = FirestoreService();
//   final TextEditingController titleController = TextEditingController();
//   final List<Map<String, dynamic>> flashcards = [];

//   CreateCardDeckScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Card Deck'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Deck Title'),
//             ),
//             const SizedBox(height: 20.0),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'Description'),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () {
//                 // TODO: Implement logic to save the new card deck
//                 Navigator.pop(context); // To close the screen after saving
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CreateCardDeckScreen extends StatefulWidget {
//   @override
//   CreateCardDeckScreenState createState() => CreateCardDeckScreenState();
// }

// class CreateCardDeckScreenState extends State<CreateCardDeckScreen> {
//   final String _selectedLanguage = 'German'; // Default language selection

//   final List<String> _targetLanguages = [
//     'German',
//     'Portuguese',
//     'Spanish',
//     'French',
//     'Mandarin Chinese',
//     'Italian',
//     'Japanese',
//   ];

//   final Map<String, String> _languageCodes = {
//     'German': 'de',
//     'Portuguese': 'pt',
//     'Spanish': 'es',
//     'French': 'fr',
//     'Mandarin Chinese': 'zh-CN',
//     'Italian': 'it',
//     'Japanese': 'ja',
//   };

//   final TranslationService _translationService = TranslationService();

//   ElevatedButton(
//     onPressed: () async {
//       String userId = _authService.getCurrentUser()?.uid ?? '';
//       if (userId.isEmpty) return;

//       // Get title, category, and selected language
//       String title = _titleController.text.trim();
//       String category = _categoryController.text.trim();
//       String targetLanguage = _selectedLanguage;

//       // Translate the title using language code
//       String sourceLanguageCode = 'en'; // Assuming English as the source language
//       String targetLanguageCode = _languageCodes[targetLanguage] ?? 'en'; // Get target language code or default to English ('en')

//       String translatedTitle = await _translationService.translateText(
//         title,
//         sourceLanguageCode,
//         targetLanguageCode,
//       );

//       // Create the card deck using FirestoreService
//       try {
//         await _firestoreService.createCardDeck(
//           userId,
//           translatedTitle,
//           category,
//           targetLanguage,
//         );

//         // Show success dialog
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Success'),
//             content: Text('Card deck created successfully.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   Navigator.pop(context); // Navigate back twice
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//       } catch (e) {
//         // Show error dialog
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Error'),
//             content: Text('Failed to create card deck. $e'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     },
//     child: Text('Create Deck'),
//   )

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   },

// }
