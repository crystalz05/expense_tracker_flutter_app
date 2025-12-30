import 'package:equatable/equatable.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpensesEvent extends ExpenseEvent {
  final String? category;
  final DateTime? from;
  final DateTime? to;

  const LoadExpensesEvent({this.category, this.from, this.to});

  @override
  List<Object?> get props => [category, from, to];
}

class AddExpenseEvent extends ExpenseEvent {
  final ExpenseParams params;
  const AddExpenseEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateExpenseEvent extends ExpenseEvent {
  final Expense expense;
  const UpdateExpenseEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String id;
  const DeleteExpenseEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SoftDeleteExpenseEvent extends ExpenseEvent {
  final String id;
  const SoftDeleteExpenseEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadExpenseByIdEvent extends ExpenseEvent {
  final String id;
  const LoadExpenseByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SyncExpensesEvent extends ExpenseEvent {
  final bool showLoading;
  const SyncExpensesEvent({this.showLoading = false});

  @override
  List<Object?> get props => [showLoading];
}

class PurgeSoftDeletedEvent extends ExpenseEvent {
  const PurgeSoftDeletedEvent();
}