import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_a_language_buddy_app_test/models/card_deck.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_auth_service.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_firestore_service.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/create_card_deck_screen.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/flashcard_list_screen.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/welcome_screen.dart';

class CardDeckListScreen extends StatelessWidget {
  final FirestoreService db = FirestoreService();
  final AuthService auth = AuthService();

  CardDeckListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? userName = auth.getCurrentUser()!.displayName;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: AppBar(
            title: Text('$userName\'s Card Deck List'),
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
                    builder: (context) => CreateCardDeckScreen(),
                  ),
                );
              },
              child: const Text(
                'Create Flashcards Deck',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<CardDeck>>(
              stream: db.getCardDecks(auth.getCurrentUser()!.uid),
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
                  List<CardDeck>? cardDecks = snapshot.data;
                  if (cardDecks == null || cardDecks.isEmpty) {
                    return const Center(
                      child: Text(
                          'No card decks found.\nClick on \'Create\' to add a new deck.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0)),
                    );
                  }
                  return ListView.builder(
                    itemCount: cardDecks.length,
                    itemBuilder: (context, index) {
                      final cardDeck = cardDecks[index];
                      return Dismissible(
                        key: Key(cardDeck.id),
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
                          db.deleteCardDeck(
                              auth.getCurrentUser()!.uid, cardDeck.id);
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlashcardListScreen(
                                  cardDeck: cardDeck,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.all(30.0),
                            child: ListTile(
                              title: Text(
                                cardDeck.title,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Category: ${cardDeck.category}',
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    'Flashcards: ${cardDeck.flashcardCount}',
                                  ),
                                  Text(
                                    'Created: ${DateFormat.yMMMd().format(cardDeck.createdAt)}',
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          ),
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
