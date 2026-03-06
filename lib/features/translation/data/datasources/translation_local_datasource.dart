// lib/features/translation/data/datasources/translation_local_datasource.dart
import 'package:sqflite/sqflite.dart';
import 'package:hive/hive.dart';
import '../../../../core/errors/failures.dart';
import '../models/translation_model.dart';

abstract class TranslationLocalDataSource {
  /// Saves a translation to the SQLite database
  Future<void> saveTranslationToHistory(TranslationModel translation);

  /// Fetches all past translations from SQLite for offline viewing
  Future<List<TranslationModel>> getTranslationHistory();

  /// Caches a recent translation in Hive to prevent redundant API calls
  Future<void> cacheRecentTranslation(TranslationModel translation);

  /// Retrieves a cached translation from Hive if it exists
  Future<TranslationModel?> getCachedTranslation(String originalText);
}

class TranslationLocalDataSourceImpl implements TranslationLocalDataSource {
  final Database sqliteDb;
  final Box hiveBox;

  TranslationLocalDataSourceImpl({
    required this.sqliteDb,
    required this.hiveBox,
  });

  @override
  Future<void> saveTranslationToHistory(TranslationModel translation) async {
    try {
      await sqliteDb.insert(
        'translations',
        translation.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw const CacheFailure('Failed to save to SQLite database');
    }
  }

  @override
  Future<List<TranslationModel>> getTranslationHistory() async {
    try {
      final List<Map<String, dynamic>> maps = await sqliteDb.query(
        'translations',
        orderBy: 'createdAt DESC',
      );
      return List.generate(
        maps.length,
        (i) => TranslationModel.fromJson(maps[i]),
      );
    } catch (e) {
      throw const CacheFailure('Failed to load history from SQLite');
    }
  }

  @override
  Future<void> cacheRecentTranslation(TranslationModel translation) async {
    try {
      // Use the original text as the Hive key to quickly check if we've translated it before
      await hiveBox.put(translation.originalText, translation.toJson());
    } catch (e) {
      throw const CacheFailure('Failed to cache to Hive');
    }
  }

  @override
  Future<TranslationModel?> getCachedTranslation(String originalText) async {
    try {
      final cachedData = hiveBox.get(originalText);
      if (cachedData != null) {
        // We have to cast the map correctly for Freezed/JSON Serializable
        final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(
          cachedData,
        );
        return TranslationModel.fromJson(jsonMap);
      }
      return null;
    } catch (e) {
      throw const CacheFailure('Failed to read from Hive cache');
    }
  }
}
