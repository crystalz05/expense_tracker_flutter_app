import 'package:equatable/equatable.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/budget_progress.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {
  const BudgetInitial();
}

class BudgetLoading extends BudgetState {
  const BudgetLoading();
}

class BudgetLoaded extends BudgetState {
  final List<Budget> budgets;

  const BudgetLoaded(this.budgets);

  @override
  List<Object?> get props => [budgets];
}

class BudgetProgressLoaded extends BudgetState {
  final BudgetProgress progress;

  const BudgetProgressLoaded(this.progress);

  @override
  List<Object?> get props => [progress];
}

class AllBudgetProgressLoaded extends BudgetState {
  final List<BudgetProgress> progress;

  const AllBudgetProgressLoaded(this.progress);

  @override
  List<Object?> get props => [progress];
}

class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object?> get props => [message];
}

class BudgetOperationSuccess extends BudgetState {
  final String message;

  const BudgetOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
