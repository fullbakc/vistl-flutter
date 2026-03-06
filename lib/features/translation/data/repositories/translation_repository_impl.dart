// lib/features/translation/data/repositories/translation_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/translation_entity.dart';
import '../../domain/repositories/translation_repository.dart';
import '../models/translation_model.dart';
import '../datasources/translation_local_datasource.dart';
import '../datasources/translation_remote_datasource.dart';
import '../datasources/ml_kit_datasource.dart'; // 👉 Added this import

class TranslationRepositoryImpl implements TranslationRepository {
  final TranslationRemoteDataSource remoteDataSource;
  final TranslationLocalDataSource localDataSource;
  final MLKitDataSource
  mlKitDataSource; // 👉 Fixed type from Object to MLKitDataSource

  TranslationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.mlKitDataSource, // 👉 Properly required now
  });

  @override
  Future<Either<Failure, TranslationEntity>> translateText(String text) async {
    try {
      // 1. Check Hive Cache First (Exam Requirement: Strategy to reduce API calls)
      final cachedTranslation = await localDataSource.getCachedTranslation(
        text,
      );
      if (cachedTranslation != null) {
        return Right(cachedTranslation.toEntity());
      }

      // 2. If not cached, call the Gemini API
      final remoteTranslation = await remoteDataSource.translateText(text);

      // 3. Cache it in Hive AND save it to SQLite History
      await localDataSource.cacheRecentTranslation(remoteTranslation);
      await localDataSource.saveTranslationToHistory(remoteTranslation);

      return Right(remoteTranslation.toEntity());
    } on ServerFailure catch (e) {
      return Left(e);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TranslationEntity>>>
  getTranslationHistory() async {
    try {
      final localHistory = await localDataSource.getTranslationHistory();
      final entities = localHistory.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveTranslation(
    TranslationEntity translation,
  ) async {
    try {
      final model = TranslationModel.fromEntity(translation);
      await localDataSource.saveTranslationToHistory(model);
      return const Right(null);
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, String>> extractTextFromImage(String imagePath) async {
    try {
      // 👉 Correctly calling ML Kit and awaiting the result to avoid main thread jank
      final extractedText = await mlKitDataSource.extractTextFromImage(
        imagePath,
      );

      if (extractedText.trim().isEmpty) {
        return const Left(
          ServerFailure("No readable text found in this image."),
        );
      }

      return Right(extractedText);
    } catch (e) {
      return Left(ServerFailure("OCR Error: ${e.toString()}"));
    }
  }
}
