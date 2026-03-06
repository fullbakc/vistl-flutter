import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

abstract class MLKitDataSource {
  Future<String> extractTextFromImage(String imagePath);
}

class MLKitDataSourceImpl implements MLKitDataSource {
  @override
  Future<String> extractTextFromImage(String imagePath) async {
    // 1. Initialize the script (Latin is default, good for English/Thai/etc.)
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final inputImage = InputImage.fromFilePath(imagePath);

      // 2. Process the image
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      // 3. Close the recognizer to free up memory/prevent main thread lag
      await textRecognizer.close();

      // 4. Return the text or throw an error if empty
      if (recognizedText.text.trim().isEmpty) {
        throw Exception("No text recognized");
      }

      return recognizedText.text;
    } catch (e) {
      await textRecognizer.close();
      rethrow;
    }
  }
}
