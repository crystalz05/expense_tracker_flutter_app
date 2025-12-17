import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/presentation/cubit/budget_cubit.dart';
import 'core/presentation/cubit/theme_cubit.dart';
import 'features/expenses/data/datasources/app_database.dart';
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
import 'features/expenses/domain/usecases/update_expense.dart';
import 'features/expenses/presentation/bloc/expense_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  final database = await $FloorAppDatabase
      .databaseBuilder("app_database.db")
      .build();

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerSingleton<AppDatabase>(database);
  sl.registerSingleton(database.expenseDao);

  // Cubits
  sl.registerLazySingleton(() => ThemeCubit(sl()));
  sl.registerLazySingleton(() => BudgetCubit(prefs: sl()));

  // Data sources
  sl.registerLazySingleton<ExpensesLocalDatasource>(
          () => ExpenseLocalDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
          () => ExpenseRepositoryImpl(localDatasource: sl()));


  sl.registerLazySingleton(() => GetExpenses(sl()));
  sl.registerLazySingleton(() => GetExpenseById(sl()));
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => UpdateExpense(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));
  sl.registerLazySingleton(() => GetExpenseByCategory(sl()));
  sl.registerLazySingleton(() => GetExpenseByDateRange(sl()));

  // Use case classes without repository dependencies
  sl.registerLazySingleton(() => GetTotalSpent());
  sl.registerLazySingleton(() => GetCategoryTotals());

  // Bloc
  sl.registerFactory(() => ExpenseBloc(
    getExpenses: sl(),
    getExpenseById: sl(),
    addExpense: sl(),
    updateExpense: sl(),
    deleteExpense: sl(),
    getExpenseByCategory: sl(),
    getExpenseByDateRange: sl(),
    getTotalSpent: sl(),
    getCategoryTotals: sl(),
  ));
}
