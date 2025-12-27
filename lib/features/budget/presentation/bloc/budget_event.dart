import 'package:equatable/equatable.dart';

import '../../domain/entities/budget.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

/// Load all budgets
class LoadBudgets extends BudgetEvent {}

/// Create new budget
class CreateBudgetEvent extends BudgetEvent {
  final Budget budget;

  const CreateBudgetEvent(this.budget);

  @override
  List<Object?> get props => [budget];
}

/// Update budget
class UpdateBudgetEvent extends BudgetEvent {
  final Budget budget;

  const UpdateBudgetEvent(this.budget);

  @override
  List<Object?> get props => [budget];
}

/// Delete budget
class DeleteBudgetEvent extends BudgetEvent {
  final String budgetId;

  const DeleteBudgetEvent(this.budgetId);

  @override
  List<Object?> get props => [budgetId];
}

/// Load progress for a single budget
class LoadBudgetProgress extends BudgetEvent {
  final String budgetId;

  const LoadBudgetProgress(this.budgetId);

  @override
  List<Object?> get props => [budgetId];
}

/// Load progress for all budgets
class LoadAllBudgetProgress extends BudgetEvent {}
