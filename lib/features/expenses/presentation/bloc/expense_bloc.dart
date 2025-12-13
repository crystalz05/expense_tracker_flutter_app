
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/add_expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/delete_expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_expense_by_id.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/get_expenses.dart';
import 'package:expenses_tracker_app/features/expenses/domain/usecases/update_expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {

  final GetExpenses getExpenses;
  final GetExpenseById getExpenseById;
  final AddExpense addExpense;
  final UpdateExpense updateExpense;
  final DeleteExpense deleteExpense;

  ExpenseBloc({
    required this.getExpenses,
    required this.getExpenseById,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense
  }): super(ExpenseInitial()){
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<LoadExpenseByIdEvent>(_onLoadExpenseById);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(
      LoadExpensesEvent event,
      Emitter<ExpenseState> emit,
      )async{
    emit(ExpenseLoading());
    final result =await getExpenses(NoParams());

    result.fold(
          (failure) => emit(ExpenseError(failure.message)),
          (expenses) => emit(ExpensesLoaded(expenses)),
    );
  }

  Future<void> _onLoadExpenseById(
      LoadExpenseByIdEvent event,
      Emitter<ExpenseState> emit,)async{
    emit(ExpenseLoading());
    final result = await getExpenseById(IdParams(id: event.id));

    result.fold(
            (failure) => emit(ExpenseError(failure.message)),
            (expense) => emit(ExpenseLoaded(expense))
    );
  }

  Future<void> _onAddExpense(
      AddExpenseEvent event,
      Emitter<ExpenseState> emit,
      )async {
    emit(ExpenseLoading());
    final result = await addExpense(event.expense);

    result.fold(
            (failure) => emit(ExpenseError(failure.message)),
            (_) async {
          emit(ExpenseActionSuccess("Expense Created Successfully"));
          add(LoadExpensesEvent());
        });
  }

  Future<void> _onUpdateExpense(
      UpdateExpenseEvent event,
      Emitter<ExpenseState> emit,
      )async {
    emit(ExpenseLoading());
    final result = await updateExpense(event.expense);

    result.fold(
        (failure) => emit(ExpenseError(failure.message)),
        (_) async {
          emit(ExpenseActionSuccess("Expense updated successfully"));
          add(LoadExpensesEvent());
        });
  }

  Future<void> _onDeleteExpense(
      DeleteExpenseEvent event,
      Emitter<ExpenseState> emit,
      )async {
    emit(ExpenseLoading());
    final result = await deleteExpense(IdParams(id: event.id));

    result.fold(
            (failure) => emit(ExpenseError(failure.message)),
        (_) async{
              emit(ExpenseActionSuccess("Expense Deleted Successfully"));
              add(LoadExpensesEvent());
        });
  }
}