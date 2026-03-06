// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:sqflite/sqflite.dart';

// Import all the layers
import '../../features/translation/domain/repositories/translation_repository.dart';
import '../../features/translation/domain/usecases/translate_text_usecase.dart';
import '../../features/translation/data/datasources/ml_kit_datasource.dart';
import '../../features/translation/data/datasources/translation_local_datasource.dart';
import '../../features/translation/data/datasources/translation_remote_datasource.dart';
import '../../features/translation/data/repositories/translation_repository_impl.dart';
import '../../features/translation/presentation/bloc/translation_bloc.dart';

final sl = GetIt.instance;

// 👉 WE NOW PASS THE DATABASES DIRECTLY INTO THIS FUNCTION
Future<void> init(Database db, Box box) async {
  // ==========================================================
  // 1. EXTERNAL PACKAGES & DATABASES
  // ==========================================================

  sl.registerLazySingleton<Database>(() => db);
  sl.registerLazySingleton<Box>(() => box);
  sl.registerLazySingleton<Dio>(() => Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 25),
    receiveTimeout: const Duration(seconds: 25),
  )));

  // ==========================================================
  // 2. FEATURES - Translation
  // ==========================================================

  // Data Sources
  sl.registerLazySingleton<TranslationRemoteDataSource>(
    () => TranslationRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<TranslationLocalDataSource>(
    () => TranslationLocalDataSourceImpl(
      sqliteDb: sl<Database>(),
      hiveBox: sl<Box>(),
    ),
  );

  sl.registerLazySingleton<MLKitDataSource>(() => MLKitDataSourceImpl());

  // Repository
  sl.registerLazySingleton<TranslationRepository>(
    () => TranslationRepositoryImpl(
      remoteDataSource: sl<TranslationRemoteDataSource>(),
      localDataSource: sl<TranslationLocalDataSource>(),
      mlKitDataSource: sl<MLKitDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<TranslateTextUseCase>(
    () => TranslateTextUseCase(sl<TranslationRepository>()),
  );

  // BLoC
  sl.registerFactory<TranslationBloc>(
    () => TranslationBloc(
      translateTextUseCase: sl<TranslateTextUseCase>(),
      repository: sl<TranslationRepository>(),
    ),
  );
}
