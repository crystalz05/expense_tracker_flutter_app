import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_budget.dart';
import '../../domain/usecases/delete_budget.dart';
import '../../domain/usecases/get_all_budget_progress.dart';
import '../../domain/usecases/get_budget.dart';
import '../../domain/usecases/get_budget_progress.dart';
import '../../domain/usecases/sync_budgets.dart';
import '../../domain/usecases/purge_soft_deleted_budgets.dart';
import '../../domain/usecases/clear_user_data.dart';
import '../../domain/usecases/update_budget.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetBudgets getBudgets;
  final CreateBudget createBudget;
  final UpdateBudget updateBudget;
  final DeleteBudget deleteBudget;
  final GetBudgetProgress getBudgetProgress;
  final GetAllBudgetProgress getAllBudgetProgress;
  final SyncBudgets syncBudgets;
  final PurgeSoftDeletedBudgets purgeSoftDeletedBudgets;
  final ClearUserData clearUserData;

  BudgetBloc({
    required this.getBudgets,
    required this.createBudget,
    required this.updateBudget,
    required this.deleteBudget,
    required this.getBudgetProgress,
    required this.getAllBudgetProgress,
    required this.syncBudgets,
    required this.purgeSoftDeletedBudgets,
    required this.clearUserData,
  }) : super(const BudgetInitial()) {
    on<LoadBudgetsEvent>(_onLoadBudgets);
    on<CreateBudgetEvent>(_onCreateBudget);
    on<UpdateBudgetEvent>(_onUpdateBudget);
    on<DeleteBudgetEvent>(_onDeleteBudget);
    on<LoadBudgetProgress>(_onLoadBudgetProgress);
    on<LoadAllBudgetProgress>(_onLoadAllBudgetProgress);
    on<SyncBudgetsEvent>(_onSyncBudgets);
    on<PurgeSoftDeletedBudgetsEvent>(_onPurgeSoftDeleted);
    on<ClearUserDataEvent>(_onClearUserData);
  }

  Future<void> _onLoadBudgets(
      LoadBudgetsEvent event,
      Emitter<BudgetState> emit,
      ) async {
    emit(const BudgetLoading());

    final result = await getBudgets(NoParams());

    result.fold(
          (failure) => emit(BudgetError(_mapFailureToMessage(failure))),
          (budgets) => emit(BudgetLoaded(budgets)),
    );
  }

  Future<void> _onCreateBudget(
      CreateBudgetEvent event,
      Emitter<BudgetState> emit,
      ) async {
    emit(const BudgetLoading());

    final result = await createBudget(
      CreateOrUpdateBudgetParams(budget: event.budget),
    );

    result.fold(
          (failure) => emit(BudgetError(_mapFailureToMessage(failure))),
          (_) {
        emit(const BudgetOperationSuccess('Budget created successfully'));
        add(const LoadBudgetsEvent());
      },
    );
  }

  Future<void> _onUpdateBudget(
      UpdateBudgetEvent event,
      Emitter<BudgetState> emit,
      ) async {
    emit(const BudgetLoading());

    final result = await updateBudget(
      CreateOrUpdateBudgetParams(budget: event.budget),
    );

    result.fold(
          (failure) => emit(BudgetError(_mapFailureToMessage(failure))),
          (_) {
        emit(const BudgetOperationSuccess('Budget updated successfully'));
        add(const LoadBudgetsEvent());
      },
    );
  }

  Future<void> _onDeleteBudget(
      DeleteBudgetEvent event,
      Emitter<BudgetState> emit,
      ) async {
    emit(const BudgetLoading());

    final result = await deleteBudget(IdParams(id: event.budgetId));

    result.fold(
          (failure) => emit(BudgetError(_mapFailureToMessage(failure))),
          (_) {
        emit(const BudgetOperationSuccess('Budget deleted successfully'));
        add(const LoadBudgetsEvent());
      },
    );
  }

  Future<void> _onLoadBudgetProgress(
      LoadBudgetProgress event,
      Emitter<BudgetState> emit,
      ) async {
    emit(const BudgetLoading());

    final result = await getBudgetProgress(event.budgetId);

    result.fold(
          (failure) => emit(BudgetError(_mapFailureToMessage(failure))),
          (progress) => emit(BudgetProgressLoaded(progress)),
    );
  }

  Future<void> _onLoadAllBudgetProgress(
      LoadAllBudgetProgress event,
      Emitter<BudgetState> emit,
      ) async {
    emit(const BudgetLoading());

    final result = await getAllBudgetProgress();

    result.fold(
          (failure) => emit(BudgetError(_mapFailureToMessage(failure))),
          (progressList) => emit(AllBudgetProgressLoaded(progressList)),
    );
  }

  Future<void> _onSyncBudgets(
      SyncBudgetsEvent event,
      Emitter<BudgetState> emit,
      ) async {
    // Don't emit loading for background sync
    final result = await syncBudgets(NoParams());

    result.fold(
          (failure) {
        // Silent fail for background sync
        print('Budget sync failed: ${_mapFailureToMessage(failure)}');
      },
          (_) {
        // Optionally reload budgets after sync
        add(const LoadBudgetsEvent());
      },
    );
  }

  Future<void> _onPurgeSoftDeleted(
      PurgeSoftDeletedBudgetsEvent event,
      Emitter<BudgetState> emit,
      ) async {
    final result = await purgeSoftDeletedBudgets(NoParams());

    result.fold(
          (failure) => emit(BudgetError(_mapFailureToMessage(failure))),
          (_) {
        emit(const BudgetOperationSuccess('Deleted budgets purged successfully'));
        add(const LoadBudgetsEvent());
      },
    );
  }

  Future<void> _onClearUserData(
      ClearUserDataEvent event,
      Emitter<BudgetState> emit,
      ) async {
    final result = await clearUserData(NoParams());

    result.fold(
          (failure) => emit(BudgetError(_mapFailureToMessage(failure))),
          (_) => emit(const BudgetOperationSuccess('User data cleared')),
    );
  }

  String _mapFailureToMessage(dynamic failure) {
    return failure.toString().replaceAll('Failure', '').trim();
  }
}