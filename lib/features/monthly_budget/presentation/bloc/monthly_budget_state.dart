import 'package:equatable/equatable.dart';

import '../../domain/entities/monthly_budget.dart';

abstract class MonthlyBudgetState extends Equatable {
  const MonthlyBudgetState();

  @override
  List<Object?> get props => [];
}

class MonthlyBudgetInitial extends MonthlyBudgetState {
  const MonthlyBudgetInitial();
}

class MonthlyBudgetLoading extends MonthlyBudgetState {
  const MonthlyBudgetLoading();
}

class MonthlyBudgetsLoaded extends MonthlyBudgetState {
  final List<MonthlyBudget> budgets;

  const MonthlyBudgetsLoaded(this.budgets);

  @override
  List<Object?> get props => [budgets];
}

class MonthlyBudgetByMonthYearLoaded extends MonthlyBudgetState {
  final MonthlyBudget? budget;

  const MonthlyBudgetByMonthYearLoaded(this.budget);

  @override
  List<Object?> get props => [budget];
}

class MonthlyBudgetError extends MonthlyBudgetState {
  final String message;

  const MonthlyBudgetError(this.message);

  @override
  List<Object?> get props => [message];
}

class MonthlyBudgetOperationSuccess extends MonthlyBudgetState {
  final String message;

  const MonthlyBudgetOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}