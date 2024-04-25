import 'package:flutter/material.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/user_login_screen.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/user_registration_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Placeholder(
              color: Colors.grey[300]!, // Placeholder color
              fallbackHeight: 200.0, // Height of the placeholder image
              // You can replace the `assetImage` property with your own image asset path
              // Ensure to replace it with a valid image path
              // assetImage: 'assets/your_image.jpg',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the login screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('Log In'),
                ),
                const SizedBox(height: 10.0),
                OutlinedButton(
                  onPressed: () {
                    // Navigate to the register screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
