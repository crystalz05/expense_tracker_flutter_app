import 'package:equatable/equatable.dart';
import '../../domain/entities/budget.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class LoadBudgetsEvent extends BudgetEvent {
  const LoadBudgetsEvent();
}

class CreateBudgetEvent extends BudgetEvent {
  final Budget budget;

  const CreateBudgetEvent(this.budget);

  @override
  List<Object?> get props => [budget];
}

class UpdateBudgetEvent extends BudgetEvent {
  final Budget budget;

  const UpdateBudgetEvent(this.budget);

  @override
  List<Object?> get props => [budget];
}

class DeleteBudgetEvent extends BudgetEvent {
  final String budgetId;

  const DeleteBudgetEvent(this.budgetId);

  @override
  List<Object?> get props => [budgetId];
}

class LoadBudgetProgress extends BudgetEvent {
  final String budgetId;

  const LoadBudgetProgress(this.budgetId);

  @override
  List<Object?> get props => [budgetId];
}

class LoadAllBudgetProgress extends BudgetEvent {
  const LoadAllBudgetProgress();
}

// NEW EVENTS
class SyncBudgetsEvent extends BudgetEvent {
  const SyncBudgetsEvent();
}

class PurgeSoftDeletedBudgetsEvent extends BudgetEvent {
  const PurgeSoftDeletedBudgetsEvent();
}

class ClearUserDataEvent extends BudgetEvent {
  const ClearUserDataEvent();
}