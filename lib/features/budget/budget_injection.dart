import 'package:get_it/get_it.dart';

import '../../core/database/app_database.dart';
import '../expenses/domain/repositories/expense_repository.dart';
import 'data/datasources/budget_local_datasource.dart';
import 'data/datasources/budget_local_datasource_impl.dart';
import 'data/repositories/budget_repository_impl.dart';
import 'domain/repositories/budget_repository.dart';
import 'domain/usecases/create_budget.dart';
import 'domain/usecases/delete_budget.dart';
import 'domain/usecases/get_all_budget_progress.dart';
import 'domain/usecases/get_budget.dart';
import 'domain/usecases/get_budget_progress.dart';
import 'domain/usecases/update_budget.dart';
import 'presentation/bloc/budget_bloc.dart';

Future<void> initBudget(GetIt sl) async {

  // DAO
  sl.registerLazySingleton(() => sl<AppDatabase>().budgetDao);

  // Local datasource
  sl.registerLazySingleton<BudgetLocalDataSource>(
        () => BudgetLocalDataSourceImpl(sl()),
  );

  // Repository (NO ExpenseDao here)
  sl.registerLazySingleton<BudgetRepository>(
        () => BudgetRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Use cases (data-only)
  sl.registerLazySingleton(() => GetBudgets(sl()));
  sl.registerLazySingleton(() => CreateBudget(sl()));
  sl.registerLazySingleton(() => UpdateBudget(sl()));
  sl.registerLazySingleton(() => DeleteBudget(sl()));

  // Use cases (cross-feature logic)
  sl.registerLazySingleton(
        () => GetBudgetProgress(
      sl<BudgetRepository>(),
      sl<ExpenseRepository>(),
    ),
  );

  sl.registerLazySingleton(
        () => GetAllBudgetProgress(
      sl<BudgetRepository>(),
      sl<ExpenseRepository>(),
    ),
  );

  // Bloc
  sl.registerFactory(
        () => BudgetBloc(
      getBudgets: sl(),
      createBudget: sl(),
      updateBudget: sl(),
      deleteBudget: sl(),
      getBudgetProgress: sl(),
      getAllBudgetProgress: sl(),
    ),
  );
}
