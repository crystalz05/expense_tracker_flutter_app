import 'package:expenses_tracker_app/features/expenses/domain/usecases/soft_delete_expense.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/add_expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/delete_expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_expense_by_category.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_expense_by_date_range.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_expense_by_id.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_expenses.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_total_by_category.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_total_spent.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/update_expense.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/sync_expenses.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetExpenses getExpenses;
  final GetExpenseById getExpenseById;
  final GetExpenseByCategory getExpenseByCategory;
  final GetExpenseByDateRange getExpenseByDateRange;
  final GetCategoryTotals getCategoryTotals;
  final GetTotalSpent getTotalSpent;
  final AddExpense addExpense;
  final UpdateExpense updateExpense;
  final DeleteExpense deleteExpense;
  final SyncExpenses syncExpenses;
  final SoftDeleteExpense softDeleteExpense;

  ExpenseBloc({
    required this.getExpenses,
    required this.getExpenseById,
    required this.getExpenseByCategory,
    required this.getExpenseByDateRange,
    required this.getCategoryTotals,
    required this.getTotalSpent,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
    required this.syncExpenses,
    required this.softDeleteExpense,
  }) : super(ExpenseInitial()) {
    on<LoadExpensesEvent>(_loadExpenses);
    on<LoadExpenseByIdEvent>(_loadExpenseById);
    on<AddExpenseEvent>(_addExpense);
    on<UpdateExpenseEvent>(_updateExpense);
    on<DeleteExpenseEvent>(_deleteExpense);
    on<SoftDeleteExpenseEvent>(_softDeleteExpense);
    on<SyncExpensesEvent>(_syncExpenses);
  }

  Future<void> _loadExpenses(
      LoadExpensesEvent event,
      Emitter<ExpenseState> emit,
      ) async {
    emit(ExpenseLoading());

    try {
      List<Expense> expenses;

      if (event.category != null) {
        final result =
        await getExpenseByCategory(CategoryParams(event.category!));
        expenses = result.fold((f) => throw Exception(f.message), (e) => e);
      } else if (event.from != null && event.to != null) {
        final result = await getExpenseByDateRange(
          DateRangeParams(start: event.from!, end: event.to!),
        );
        expenses = result.fold((f) => throw Exception(f.message), (e) => e);
      } else {
        final result = await getExpenses(NoParams());
        expenses = result.fold((f) => throw Exception(f.message), (e) => e);
      }

      emit(
        ExpensesLoaded(
          expenses,
          getTotalSpent(expenses),
          getCategoryTotals(expenses),
        ),
      );
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }


  Future<void> _loadExpenseById(
      LoadExpenseByIdEvent event,
      Emitter<ExpenseState> emit,
      ) async {
    emit(ExpenseLoading());

    final result = await getExpenseById(IdParams(id: event.id));

    result.fold(
          (f) => emit(ExpenseError(f.message)),
          (expense) => emit(ExpenseLoaded(expense)),
    );
  }

  Future<void> _addExpense(
      AddExpenseEvent event,
      Emitter<ExpenseState> emit,
      ) async {
    emit(ExpenseLoading());

    final result = await addExpense(event.params);

    result.fold(
          (f) => emit(ExpenseError(f.message)),
          (_) {
        emit(const ExpenseActionSuccess("Expense created successfully"));
        add(SyncExpensesEvent());
        add(LoadExpensesEvent());
      },
    );
  }

  Future<void> _updateExpense(
      UpdateExpenseEvent event,
      Emitter<ExpenseState> emit,
      ) async {
    emit(ExpenseLoading());

    final result = await updateExpense(event.expense);

    result.fold(
          (f) => emit(ExpenseError(f.message)),
          (_) {
        emit(const ExpenseActionSuccess("Expense updated successfully"));
        add(SyncExpensesEvent());
        add(LoadExpensesEvent());
      },
    );
  }

  Future<void> _deleteExpense(
      DeleteExpenseEvent event,
      Emitter<ExpenseState> emit,
      ) async {
    emit(ExpenseLoading());

    final result = await deleteExpense(IdParams(id: event.id));

    result.fold(
          (f) => emit(ExpenseError(f.message)),
          (_) {
        emit(const ExpenseActionSuccess("Expense deleted successfully"));
        add(SyncExpensesEvent());
        add(LoadExpensesEvent());
      },
    );
  }

  Future<void> _softDeleteExpense(
      SoftDeleteExpenseEvent event,
      Emitter<ExpenseState> emit,
      ) async {
    emit(ExpenseLoading());

    final result = await softDeleteExpense(IdParams(id: event.id));

    result.fold(
          (f) => emit(ExpenseError(f.message)),
          (_) {
        emit(const ExpenseActionSuccess("Expense deleted successfully"));
        add(SyncExpensesEvent());
        add(LoadExpensesEvent());
      },
    );
  }

  Future<void> _syncExpenses(
      SyncExpensesEvent event,
      Emitter<ExpenseState> emit,
      ) async {
    final result = await syncExpenses(NoParams());

    result.fold(
          (f) => emit(ExpenseError(f.message)),
          (_) => add(LoadExpensesEvent()),
    );
  }
}
