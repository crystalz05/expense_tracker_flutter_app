  import 'package:equatable/equatable.dart';

  import '../../domain/entities/budget.dart';
  import '../../domain/entities/budget_progress.dart';

  abstract class BudgetState extends Equatable {
    const BudgetState();

    @override
    List<Object?> get props => [];
  }

  /// Initial
  class BudgetInitial extends BudgetState {}

  /// Loading
  class BudgetLoading extends BudgetState {}

  /// Budgets loaded
  class BudgetLoaded extends BudgetState {
    final List<Budget> budgets;

    const BudgetLoaded(this.budgets);

    @override
    List<Object?> get props => [budgets];
  }

  /// Budget progress loaded (single)
  class BudgetProgressLoaded extends BudgetState {
    final BudgetProgress progress;

    const BudgetProgressLoaded(this.progress);

    @override
    List<Object?> get props => [progress];
  }

  /// Budget progress loaded (all)
  class AllBudgetProgressLoaded extends BudgetState {
    final List<BudgetProgress> progress;

    const AllBudgetProgressLoaded(this.progress);

    @override
    List<Object?> get props => [progress];
  }

  /// Error
  class BudgetError extends BudgetState {
    final String message;

    const BudgetError(this.message);

    @override
    List<Object?> get props => [message];
  }
