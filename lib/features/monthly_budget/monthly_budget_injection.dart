import 'package:expenses_tracker_app/features/monthly_budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../core/database/app_database.dart';
import '../../core/network/network_info.dart';
import '../auth/domain/user_session/user_session.dart';
import 'data/datasources/monthly_budget_local_datasource.dart';
import 'data/datasources/monthly_budget_local_datasource_impl.dart';
import 'data/datasources/monthly_budget_remote_datasource.dart';
import 'data/datasources/monthly_budget_remote_datasource_impl.dart';
import 'data/repositories/monthly_budget_repository_impl.dart';
import 'domain/repositories/monthly_budget_repository.dart';
import 'domain/usecases/clear_user_data.dart';
import 'domain/usecases/create_monthly_budget.dart';
import 'domain/usecases/delete_monthly_budget.dart';
import 'domain/usecases/get_monthly_budget_by_month_year.dart';
import 'domain/usecases/get_monthly_budget_by_year.dart';
import 'domain/usecases/get_monthly_budgets.dart';
import 'domain/usecases/get_monthly_budgets_by_id.dart';
import 'domain/usecases/purge_soft_deleted_monthly_budgets.dart';
import 'domain/usecases/sync_monthly_budgets.dart';
import 'domain/usecases/update_monthly_budget.dart';

Future<void> initMonthlyBudget(GetIt sl) async {
  // DAO
  sl.registerLazySingleton(() => sl<AppDatabase>().monthlyBudgetDao);

  // Data sources
  sl.registerLazySingleton<MonthlyBudgetLocalDataSource>(
    () => MonthlyBudgetLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<MonthlyBudgetRemoteDataSource>(
    () => MonthlyBudgetRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<MonthlyBudgetRepository>(
    () => MonthlyBudgetRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl<NetworkInfo>(),
      userSession: sl<UserSession>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMonthlyBudgets(sl()));
  sl.registerLazySingleton(() => GetMonthlyBudgetById(sl()));
  sl.registerLazySingleton(() => GetMonthlyBudgetByMonthYear(sl()));
  sl.registerLazySingleton(() => GetMonthlyBudgetsByYear(sl()));
  sl.registerLazySingleton(() => CreateMonthlyBudget(sl()));
  sl.registerLazySingleton(() => UpdateMonthlyBudget(sl()));
  sl.registerLazySingleton(() => DeleteMonthlyBudget(sl()));
  sl.registerLazySingleton(() => SyncMonthlyBudgets(sl()));
  sl.registerLazySingleton(() => PurgeSoftDeletedMonthlyBudgets(sl()));
  sl.registerLazySingleton(() => ClearMonthlyBudgetUserData(sl()));

  // Bloc
  sl.registerFactory(
    () => MonthlyBudgetBloc(
      getMonthlyBudgets: sl(),
      getMonthlyBudgetByMonthYear: sl(),
      getMonthlyBudgetsByYear: sl(),
      createMonthlyBudget: sl(),
      updateMonthlyBudget: sl(),
      deleteMonthlyBudget: sl(),
      syncMonthlyBudgets: sl(),
      purgeSoftDeletedMonthlyBudgets: sl(),
      clearUserData: sl(),
    ),
  );
}
