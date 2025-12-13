
import 'package:expenses_tracker_app/features/expenses/data/datasources/expenses_local_datasource.dart';
import 'package:expenses_tracker_app/features/expenses/data/datasources/expenses_local_datasource_impl.dart';
import 'package:expenses_tracker_app/features/expenses/data/models/expense_model.dart';
import 'package:expenses_tracker_app/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/add_expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/delete_expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_expense_by_id.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_expenses.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_total_by_category.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_total_spent.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/update_expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

final sl = GetIt.instance;

Future<void> init() async {


  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());
  final expenseBox = await Hive.openBox<ExpenseModel>('expense_box');

  sl.registerLazySingleton<ExpensesLocalDatasource>(
      ()=> ExpenseLocalDataSourceImpl(expenseBox),
  );

  sl.registerLazySingleton<ExpenseRepository>(
      ()=> ExpenseRepositoryImpl(localDatasource: sl<ExpensesLocalDatasource>()),
  );

  sl.registerLazySingleton(()=> GetCategoryTotals());
  sl.registerLazySingleton(()=> GetTotalSpent());
  sl.registerLazySingleton(()=> GetExpenses(sl()));
  sl.registerLazySingleton(()=> GetExpenseById(sl()));
  sl.registerLazySingleton(()=> AddExpense(sl()));
  sl.registerLazySingleton(()=> UpdateExpense(sl()));
  sl.registerLazySingleton(()=> DeleteExpense(sl()));

  sl.registerFactory(
      ()=> ExpenseBloc(
          getCategoryTotals: sl(),
          getTotalSpent: sl(),
          getExpenses: sl(),
          getExpenseById: sl(),
          addExpense: sl(),
          updateExpense: sl(),
          deleteExpense: sl()
      )
  );
}