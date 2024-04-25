import 'package:flutter/material.dart';
import 'package:learn_a_language_buddy_app_test/services/fb_auth_service.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/card_deck_list_screen.dart';
import 'package:learn_a_language_buddy_app_test/ui_screens/welcome_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: AppBar(
            title: const Text('Register'),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: displayNameController,
                decoration: const InputDecoration(labelText: 'Display Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a display name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30.0),
              OutlinedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        await authService.registerWithEmailAndPassword(
                          displayNameController.text.trim(),
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                        await authService.updateUserDisplayName(
                          displayNameController.text.trim(),
                        );

                        //Don't build across async gaps
                        if (!context.mounted) {
                          return;
                        }

                        showSnackBar('Registration successful.');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CardDeckListScreen(),
                          ),
                        );
                      } catch (e) {
                        showSnackBar(e.toString());
                        print('Error registering user: $e');
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
              const SizedBox(height: 10.0),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  );
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
    super.dispose();
  }
}
