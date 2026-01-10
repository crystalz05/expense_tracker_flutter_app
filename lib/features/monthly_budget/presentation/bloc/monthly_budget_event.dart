import 'package:equatable/equatable.dart';
import '../../domain/entities/monthly_budget.dart';

abstract class MonthlyBudgetEvent extends Equatable {
  const MonthlyBudgetEvent();

  @override
  List<Object?> get props => [];
}

class LoadMonthlyBudgetsEvent extends MonthlyBudgetEvent {
  const LoadMonthlyBudgetsEvent();
}

class LoadMonthlyBudgetByMonthYearEvent extends MonthlyBudgetEvent {
  final int month;
  final int year;

  const LoadMonthlyBudgetByMonthYearEvent({
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [month, year];
}

class LoadMonthlyBudgetsByYearEvent extends MonthlyBudgetEvent {
  final int year;

  const LoadMonthlyBudgetsByYearEvent({required this.year});

  @override
  List<Object?> get props => [year];
}

class CreateMonthlyBudgetEvent extends MonthlyBudgetEvent {
  final MonthlyBudget monthlyBudget;

  const CreateMonthlyBudgetEvent(this.monthlyBudget);

  @override
  List<Object?> get props => [monthlyBudget];
}

class UpdateMonthlyBudgetEvent extends MonthlyBudgetEvent {
  final MonthlyBudget monthlyBudget;

  const UpdateMonthlyBudgetEvent(this.monthlyBudget);

  @override
  List<Object?> get props => [monthlyBudget];
}

class DeleteMonthlyBudgetEvent extends MonthlyBudgetEvent {
  final String budgetId;

  const DeleteMonthlyBudgetEvent(this.budgetId);

  @override
  List<Object?> get props => [budgetId];
}

class SyncMonthlyBudgetsEvent extends MonthlyBudgetEvent {
  const SyncMonthlyBudgetsEvent();
}

class PurgeSoftDeletedMonthlyBudgetsEvent extends MonthlyBudgetEvent {
  const PurgeSoftDeletedMonthlyBudgetsEvent();
}

class ClearMonthlyBudgetUserDataEvent extends MonthlyBudgetEvent {
  const ClearMonthlyBudgetUserDataEvent();
}