import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expenses_tracker_app/core/network/network_info.dart';
import 'package:expenses_tracker_app/features/budget/budget_injection.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_by_category_and_period.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/soft_delete_expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/sync_expenses.dart';
import 'package:expenses_tracker_app/features/user_profile/user_profile_injection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/supabase_constants.dart';
import 'core/presentation/cubit/budget_cubit.dart';
import 'core/presentation/cubit/theme_cubit.dart';
import 'core/presentation/cubit/offline_mode_cubit.dart';
import 'core/security/secure_storage_service.dart';
import 'core/security/database_encryption_key_manager.dart';
import 'core/security/encryption_migration.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/domain/user_session/user_session.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'core/database/app_database.dart';
import 'core/database/encrypted_database_factory.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as sqflite;
import 'features/expenses/data/datasources/expense_remote_datasource.dart';
import 'features/expenses/data/datasources/expense_remote_datasource_impl.dart';
import 'features/expenses/data/datasources/expenses_local_datasource.dart';
import 'features/expenses/data/datasources/expenses_local_datasource_impl.dart';
import 'features/expenses/data/repositories/expense_repository_impl.dart';
import 'features/expenses/domain/repositories/expense_repository.dart';
import 'features/expenses/domain/usecases/add_expense.dart';
import 'features/expenses/domain/usecases/delete_expense.dart';
import 'features/expenses/domain/usecases/get_expense_by_category.dart';
import 'features/expenses/domain/usecases/get_expense_by_date_range.dart';
import 'features/expenses/domain/usecases/get_expense_by_id.dart';
import 'features/expenses/domain/usecases/get_expenses.dart';
import 'features/expenses/domain/usecases/get_total_by_category.dart';
import 'features/expenses/domain/usecases/get_total_spent.dart';
import 'features/expenses/domain/usecases/purge_soft_delete.dart';
import 'features/expenses/domain/usecases/update_expense.dart';
import 'features/expenses/presentation/bloc/expense_bloc.dart';
import 'features/analytics/analytics_injection.dart';
import 'features/monthly_budget/monthly_budget_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Supabase initialization
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl<SupabaseClient>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDatasource>()),
  );

  // Shared Preferences (needed before security services)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Security Services
  final flutterSecureStorage = const FlutterSecureStorage();
  sl.registerLazySingleton(() => flutterSecureStorage);

  final secureStorageService = SecureStorageService(flutterSecureStorage);
  sl.registerLazySingleton(() => secureStorageService);

  final encryptionKeyManager = DatabaseEncryptionKeyManager(secureStorageService);
  sl.registerLazySingleton(() => encryptionKeyManager);

  final encryptionMigration = EncryptionMigration(encryptionKeyManager);
  sl.registerLazySingleton(() => encryptionMigration);

  // Get or create encryption key
  final encryptionKey = await encryptionKeyManager.getOrCreateEncryptionKey();

  // Check if migration is needed
  final needsMigration = await encryptionMigration.needsMigration(
    '${await sqflite.getDatabasesPath()}/app_database.db',
  );

  if (needsMigration) {
    // Migrate existing unencrypted database to encrypted version
    await encryptionMigration.migrateToEncrypted(
      '${await sqflite.getDatabasesPath()}/app_database.db',
      encryptionKey,
    );
  }

  // Database with encryption
  final database = await EncryptedDatabaseFactory.createEncrypted(
    databaseName: 'app_database.db',
    encryptionKey: encryptionKey,
  );

  sl.registerSingleton<AppDatabase>(database);
  sl.registerSingleton(database.expenseDao);

  // Cubits
  sl.registerLazySingleton(() => ThemeCubit(sl()));
  sl.registerLazySingleton(() => BudgetCubit(prefs: sl()));
  sl.registerLazySingleton(() => OfflineModeCubit(sl())); // NEW

  // Data sources
  sl.registerLazySingleton<ExpensesLocalDatasource>(
    () => ExpenseLocalDataSourceImpl(sl()),
  );

  // User session
  sl.registerLazySingleton<UserSession>(
    () => UserSessionImpl(Supabase.instance.client),
  );

  // Remote data source
  sl.registerLazySingleton<ExpenseRemoteDatasource>(
    () => ExpenseRemoteDatasourceImpl(Supabase.instance.client),
  );

  // Network - UPDATED to include SharedPreferences
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl(), sl()));

  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
      networkInfo: sl(),
      userSession: sl(),
    ),
  );

  // Auth use cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
      authRepository: sl(),
    ),
  );

  // Expense use cases
  sl.registerLazySingleton(() => GetExpenses(sl()));
  sl.registerLazySingleton(() => GetExpenseById(sl()));
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => UpdateExpense(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));
  sl.registerLazySingleton(() => GetExpenseByCategory(sl()));
  sl.registerLazySingleton(() => GetExpenseByDateRange(sl()));
  sl.registerLazySingleton(() => SyncExpenses(sl()));
  sl.registerLazySingleton(() => SoftDeleteExpense(sl()));
  sl.registerLazySingleton(() => PurgeSoftDeleted(sl()));
  sl.registerLazySingleton(() => GetByCategoryAndPeriod(sl()));

  // Use case classes without repository dependencies
  sl.registerLazySingleton(() => GetTotalSpent());
  sl.registerLazySingleton(() => GetCategoryTotals());

  await initBudget(sl);
  await initAnalytics(sl);
  await initUserProfile(sl);
  await initMonthlyBudget(sl);

  // Bloc
  sl.registerFactory(
    () => ExpenseBloc(
      getExpenses: sl(),
      getExpenseById: sl(),
      addExpense: sl(),
      updateExpense: sl(),
      deleteExpense: sl(),
      getExpenseByCategory: sl(),
      getExpenseByDateRange: sl(),
      getTotalSpent: sl(),
      getCategoryTotals: sl(),
      syncExpenses: sl(),
      softDeleteExpense: sl(),
      purgeSoftDeleted: sl(),
      getByCategoryAndPeriod: sl(),
    ),
  );
}
