import 'package:flutter/material.dart';
//import 'package:learn_a_language_buddy_app_test/ui_screens/card_deck_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:learn_a_language_buddy_app_test/ui_screens/create_card_deck_screen.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/welcome_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WelcomeScreen(),
    );
  }
}
