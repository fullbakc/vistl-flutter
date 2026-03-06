import 'dart:io';
import '../../../../core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_route/auto_route.dart'; // 👉 Added for routing

// Import your generated router file if you use strong typing (e.g., const HistoryRoute())
// import '../../../../core/routes/app_router.gr.dart';

import '../bloc/translation_bloc.dart';
import '../bloc/translation_event.dart';
import '../bloc/translation_state.dart';

@RoutePage() // 👉 Make sure this annotation is here for auto_route!
class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  final _textController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      // Trigger the BLoC to extract text and translate
      context.read<TranslationBloc>().add(
        ExtractAndTranslateTextEvent(image.path),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VisTL - Visual Translator'),
        actions: [
          // 👉 Restored the History Icon!
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Translation History',
            onPressed: () {
              // Navigate to History Page using auto_route
              // If you are using generated typed routes, change this to:
              // context.pushRoute(const HistoryRoute());
              context.router.push(const HistoryRoute());
            },
          ),
        ],
      ),
      body: BlocConsumer<TranslationBloc, TranslationState>(
        listener: (context, state) {
          if (state is TranslationSuccess) {
            _textController.text = state.translation.translatedText;
          }
          if (state is TranslationError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Image Preview Area
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.contain,
                          ),
                        )
                      : const Center(child: Text('No image selected')),
                ),
                const SizedBox(height: 20),

                // Action Button
                ElevatedButton.icon(
                  onPressed: state is TranslationLoading ? null : _pickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Select Image to Translate'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),

                const SizedBox(height: 20),
                if (state is TranslationLoading)
                  const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("Translating via AI..."), // Adds a nice UX touch
                    ],
                  ),

                // Results Area (Implicit Animation)
                AnimatedOpacity(
                  opacity: state is TranslationSuccess ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Translated Text:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _textController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.blue.withOpacity(0.05),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

extension on StackRouter {
  void pushNamed(String s) {}
}
