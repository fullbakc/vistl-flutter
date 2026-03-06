// lib/features/translation/data/datasources/translation_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/../core/errors/failures.dart';
import '../models/translation_model.dart';

abstract class TranslationRemoteDataSource {
  /// Calls the Gemini API to translate the text.
  /// Throws a [ServerException] for all error codes.
  Future<TranslationModel> translateText(String text);
}

class TranslationRemoteDataSourceImpl implements TranslationRemoteDataSource {
  final Dio dio;

  TranslationRemoteDataSourceImpl({required this.dio});

  @override
  Future<TranslationModel> translateText(String text) async {
    try {
      // NOTE: In production, the API key must be in a .env file per exam rules!
      // Example endpoint for Gemini (adjust to the actual endpoint and model you use)
      final String _baseUrl =
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"; // 👉 Changed from 'pro' to 'flash'

// In your request body, ensure you are using the correct model name if your SDK requires it
final response = await dio.post(
  "$_baseUrl?key=${dotenv.env['GEMINI_API_KEY']}",
  data: {
    "contents": [
      {
        "parts": [
          {"text": "Translate the following text to english: $text"}
        ]
      }
    ],
    // Optional: Add generationConfig to make it even faster/shorter
    "generationConfig": {
      "temperature": 0.1, // Lower temperature makes translation more stable and faster
      "maxOutputTokens": 1000,
    }
  },
);

      if (response.statusCode == 200) {
        // Parse the specific JSON structure Gemini returns
        final String translatedString =
            response.data['candidates'][0]['content']['parts'][0]['text'];

        return TranslationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          originalText: text,
          translatedText: translatedString,
          createdAt: DateTime.now(),
        );
      } else {
        throw const ServerFailure('Failed to translate text');
      }
    } catch (e) {
      throw ServerFailure('API Error: ${e.toString()}');
    }
  }
}
