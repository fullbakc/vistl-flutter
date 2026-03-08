# VisTL - Visual Translator

VisTL is an advanced, offline-first Flutter application that extracts text from images using on-device Machine Learning and translates it instantly using generative AI.

Built with **Clean Architecture**, this project demonstrates enterprise-level state management, dependency injection, local caching, and comprehensive testing.

## Key Features
* **On-Device OCR:** Utilizes Google ML Kit to extract text directly from local images (e.g., screenshots, technical diagrams, or raw manga pages) without sending unencrypted image data over the network.
* **AI-Powered Translation:** Integrates the Gemini 2.5 Flash API for lightning-fast, context-aware text translation.
* **Offline History:** Automatically caches recent translations using **Hive** (NoSQL) and permanently archives history using **SQLite** (Relational).
* **Responsive State Management:** Powered by `flutter_bloc` for seamless UI updates and predictable data flow.

## Tech Stack
* **Framework:** Flutter (Dart)
* **Architecture:** Clean Architecture (Domain, Data, Presentation layers)
* **State Management:** BLoC (`flutter_bloc`)
* **Dependency Injection:** `get_it`
* **Local Storage:** `sqflite` (History) & `hive` (Cache)
* **Networking & AI:** `dio`, Google Generative AI (Gemini 2.5 Flash)
* **Machine Learning:** `google_mlkit_text_recognition`
* **Routing:** `auto_route`

## Getting Started

### 1. Clone the Repository
```
git clone <your-repo-url>
cd vistl
```

### 2. Install Dependencies

```
flutter pub get
```

### 3. Environment Setup (.env)
This application requires a Gemini API key. Create a .env file in the root directory and add your key:

```
GEMINI_API_KEY=your_actual_api_key_here
```

### 4. Code Generation
If you make changes to the router, run the build runner to regenerate the routing files:

```
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run the App

```
flutter run
```

Testing
This project strictly follows the Testing Pyramid, implementing Unit, Widget, and Integration tests using mocktail and integration_test.

Run Unit & Widget Tests:

```
flutter test
```

Run End-to-End Integration Test: (Requires a running emulator/device)

```
flutter test integration_test/app_test.dart
```