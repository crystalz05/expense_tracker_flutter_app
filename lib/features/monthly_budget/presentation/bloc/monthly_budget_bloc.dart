import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/clear_user_data.dart';
import '../../domain/usecases/create_monthly_budget.dart';
import '../../domain/usecases/delete_monthly_budget.dart';
import '../../domain/usecases/get_monthly_budget_by_month_year.dart';
import '../../domain/usecases/get_monthly_budget_by_year.dart';
import '../../domain/usecases/get_monthly_budgets.dart';
import '../../domain/usecases/purge_soft_deleted_monthly_budgets.dart';
import '../../domain/usecases/sync_monthly_budgets.dart';
import '../../domain/usecases/update_monthly_budget.dart';
import 'monthly_budget_event.dart';
import 'monthly_budget_state.dart';

class MonthlyBudgetBloc extends Bloc<MonthlyBudgetEvent, MonthlyBudgetState> {
  final GetMonthlyBudgets getMonthlyBudgets;
  final GetMonthlyBudgetByMonthYear getMonthlyBudgetByMonthYear;
  final GetMonthlyBudgetsByYear getMonthlyBudgetsByYear;
  final CreateMonthlyBudget createMonthlyBudget;
  final UpdateMonthlyBudget updateMonthlyBudget;
  final DeleteMonthlyBudget deleteMonthlyBudget;
  final SyncMonthlyBudgets syncMonthlyBudgets;
  final PurgeSoftDeletedMonthlyBudgets purgeSoftDeletedMonthlyBudgets;
  final ClearMonthlyBudgetUserData clearUserData;

  MonthlyBudgetBloc({
    required this.getMonthlyBudgets,
    required this.getMonthlyBudgetByMonthYear,
    required this.getMonthlyBudgetsByYear,
    required this.createMonthlyBudget,
    required this.updateMonthlyBudget,
    required this.deleteMonthlyBudget,
    required this.syncMonthlyBudgets,
    required this.purgeSoftDeletedMonthlyBudgets,
    required this.clearUserData,
  }) : super(const MonthlyBudgetInitial()) {
    on<LoadMonthlyBudgetsEvent>(_onLoadMonthlyBudgets);
    on<LoadMonthlyBudgetByMonthYearEvent>(_onLoadMonthlyBudgetByMonthYear);
    on<LoadMonthlyBudgetsByYearEvent>(_onLoadMonthlyBudgetsByYear);
    on<CreateMonthlyBudgetEvent>(_onCreateMonthlyBudget);
    on<UpdateMonthlyBudgetEvent>(_onUpdateMonthlyBudget);
    on<DeleteMonthlyBudgetEvent>(_onDeleteMonthlyBudget);
    on<SyncMonthlyBudgetsEvent>(_onSyncMonthlyBudgets);
    on<PurgeSoftDeletedMonthlyBudgetsEvent>(_onPurgeSoftDeleted);
    on<ClearMonthlyBudgetUserDataEvent>(_onClearUserData);
  }

  Future<void> _onLoadMonthlyBudgets(
      LoadMonthlyBudgetsEvent event,
      Emitter<MonthlyBudgetState> emit,
      ) async {
    emit(const MonthlyBudgetLoading());

    final result = await getMonthlyBudgets(NoParams());

    result.fold(
          (failure) => emit(MonthlyBudgetError(_mapFailureToMessage(failure))),
          (budgets) => emit(MonthlyBudgetsLoaded(budgets)),
    );
  }

  Future<void> _onLoadMonthlyBudgetByMonthYear(
      LoadMonthlyBudgetByMonthYearEvent event,
      Emitter<MonthlyBudgetState> emit,
      ) async {
    emit(const MonthlyBudgetLoading());

    final result = await getMonthlyBudgetByMonthYear(
      MonthYearParams(month: event.month, year: event.year),
    );

    result.fold(
          (failure) => emit(MonthlyBudgetError(_mapFailureToMessage(failure))),
          (budget) => emit(MonthlyBudgetByMonthYearLoaded(budget)),
    );
  }

  Future<void> _onLoadMonthlyBudgetsByYear(
      LoadMonthlyBudgetsByYearEvent event,
      Emitter<MonthlyBudgetState> emit,
      ) async {
    emit(const MonthlyBudgetLoading());

    final result = await getMonthlyBudgetsByYear(YearParams(year: event.year));

    result.fold(
          (failure) => emit(MonthlyBudgetError(_mapFailureToMessage(failure))),
          (budgets) => emit(MonthlyBudgetsLoaded(budgets)),
    );
  }

  Future<void> _onCreateMonthlyBudget(
      CreateMonthlyBudgetEvent event,
      Emitter<MonthlyBudgetState> emit,
      ) async {
    emit(const MonthlyBudgetLoading());

    final result = await createMonthlyBudget(
      MonthlyBudgetParams(monthlyBudget: event.monthlyBudget),
    );

    result.fold(
          (failure) => emit(MonthlyBudgetError(_mapFailureToMessage(failure))),
          (_) {
        emit(const MonthlyBudgetOperationSuccess('Monthly budget created successfully'));
        add(const LoadMonthlyBudgetsEvent());
      },
    );
  }

  Future<void> _onUpdateMonthlyBudget(
      UpdateMonthlyBudgetEvent event,
      Emitter<MonthlyBudgetState> emit,
      ) async {
    emit(const MonthlyBudgetLoading());

    final result = await updateMonthlyBudget(
      MonthlyBudgetParams(monthlyBudget: event.monthlyBudget),
    );

    result.fold(
          (failure) => emit(MonthlyBudgetError(_mapFailureToMessage(failure))),
          (_) {
        emit(const MonthlyBudgetOperationSuccess('Monthly budget updated successfully'));
        add(const LoadMonthlyBudgetsEvent());
      },
    );
  }

  Future<void> _onDeleteMonthlyBudget(
      DeleteMonthlyBudgetEvent event,
      Emitter<MonthlyBudgetState> emit,
      ) async {
    emit(const MonthlyBudgetLoading());

    final result = await deleteMonthlyBudget(IdParams(id: event.budgetId));

    result.fold(
          (failure) => emit(MonthlyBudgetError(_mapFailureToMessage(failure))),
          (_) {
        emit(const MonthlyBudgetOperationSuccess('Monthly budget deleted successfully'));
        add(const LoadMonthlyBudgetsEvent());
      },
    );
  }

  Future<void> _onSyncMonthlyBudgets(
      SyncMonthlyBudgetsEvent event,
      Emitter<MonthlyBudgetState> emit,
      ) async {
    final result = await syncMonthlyBudgets(NoParams());

    result.fold(
          (failure) {
        print('Monthly budget sync failed: ${_mapFailureToMessage(failure)}');
      },
          (_) {
        add(const LoadMonthlyBudgetsEvent());
      },
    );
  }

  Future<void> _onPurgeSoftDeleted(
      PurgeSoftDeletedMonthlyBudgetsEvent event,
      Emitter<MonthlyBudgetState> emit,
      ) async {
    final result = await purgeSoftDeletedMonthlyBudgets(NoParams());

    result.fold(
          (failure) => emit(MonthlyBudgetError(_mapFailureToMessage(failure))),
          (_) {
        emit(const MonthlyBudgetOperationSuccess('Deleted budgets purged successfully'));
        add(const LoadMonthlyBudgetsEvent());
      },
    );
  }

  Future<void> _onClearUserData(
      ClearMonthlyBudgetUserDataEvent event,
      Emitter<MonthlyBudgetState> emit,
      ) async {
    final result = await clearUserData(NoParams());

    result.fold(
          (failure) => emit(MonthlyBudgetError(_mapFailureToMessage(failure))),
          (_) => emit(const MonthlyBudgetOperationSuccess('User data cleared')),
    );
  }

  String _mapFailureToMessage(dynamic failure) {
    return failure.toString().replaceAll('Failure', '').trim();
  }
}