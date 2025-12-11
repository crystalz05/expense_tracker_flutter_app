
import 'package:equatable/equatable.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';

abstract class ExpenseState extends Equatable{
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState{}

class ExpenseLoading extends ExpenseState{}

class ExpenseError extends ExpenseState{
  final String message;
  const ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}

class ExpensesLoaded extends ExpenseState{
  final List<Expense> expenses;
  const ExpensesLoaded(this.expenses);

  @override
  List<Object?> get props => [expenses];
}

class ExpenseLoaded extends ExpenseState{
  final Expense expense;
  const ExpenseLoaded(this.expense);

  @override
  List<Object?> get props => [expense];
}

class ExpenseActionSuccess extends ExpenseState{
  final String message;
  const ExpenseActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}