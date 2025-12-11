
import 'package:equatable/equatable.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpensesEvent extends ExpenseEvent{}

class LoadExpenseByIdEvent extends ExpenseEvent{
  final String id;
  const LoadExpenseByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AddExpenseEvent extends ExpenseEvent{
  final Expense expense;
  const AddExpenseEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteExpenseEvent extends ExpenseEvent{
  final String id;
  const DeleteExpenseEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateExpenseEvent extends ExpenseEvent{
  final Expense expense;
  const UpdateExpenseEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}
