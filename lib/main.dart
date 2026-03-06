// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'core/di/injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'features/translation/presentation/bloc/translation_bloc.dart';

void main() async {
  // Ensure this is the VERY first line
  WidgetsFlutterBinding.ensureInitialized();

  // Wrap everything in a try-catch so it doesn't silent-crash
  try {
    await dotenv.load(fileName: ".env");

    // Initialize DBs BEFORE calling get_it init
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    final box = await Hive.openBox('translation_cache');

    final dbPath = await getDatabasesPath();
    final sqliteDb = await openDatabase(
      join(dbPath, 'visiontrans.db'),
      version: 1,
    );

    // Now pass them to init
    await di.init(sqliteDb, box);

    runApp(MyApp());
  } catch (e) {
    debugPrint("FATAL STARTUP ERROR: $e");
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TranslationBloc>(create: (_) => di.sl<TranslationBloc>()),
      ],
      child: MaterialApp.router(
        title: 'VisTL',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        routerConfig: _appRouter.config(),
      ),
    );
  }
}