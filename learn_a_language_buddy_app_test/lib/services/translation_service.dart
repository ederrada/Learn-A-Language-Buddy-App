import 'package:translator/translator.dart';

class TranslationService {
  final translator = GoogleTranslator();

  //final translator = Translator(apiKey: 'AIzaSyC2n8BxP8pJZAaPZCrmMMNa_D4okhvN8Xs');

  Future<String> translateText(
      String text, String sourceLanguage, String targetLanguage) async {
    try {
      var translation = await translator.translate(text,
          from: sourceLanguage, to: targetLanguage);
      return translation.text;
    } catch (error) {
      print('Translation error: $error');
      return 'Error: Translation failed.';
    }
  }
}
