// import 'package:expenses_tracker_app/features/budget/presentation/dummy_data/mock_data.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../core/presentation/cubit/budget_cubit.dart';
// import '../../../../core/usecases/usecase.dart';
// import '../../domain/usecases/create_budget.dart';
// import '../../domain/usecases/delete_budget.dart';
// import '../../domain/usecases/get_all_budget_progress.dart';
// import '../../domain/usecases/get_budget.dart';
// import '../../domain/usecases/get_budget_progress.dart';
// import '../../domain/usecases/update_budget.dart';
// import 'budget_event.dart';
// import 'budget_state.dart';
//
// class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
//   final GetBudgets getBudgets;
//   final CreateBudget createBudget;
//   final UpdateBudget updateBudget;
//   final DeleteBudget deleteBudget;
//   final GetBudgetProgress getBudgetProgress;
//   final GetAllBudgetProgress getAllBudgetProgress;
//
//   BudgetBloc({
//     required this.getBudgets,
//     required this.createBudget,
//     required this.updateBudget,
//     required this.deleteBudget,
//     required this.getBudgetProgress,
//     required this.getAllBudgetProgress,
//   }) : super(BudgetInitial()) {
//
//     on<LoadBudgets>(_onLoadBudgets);
//     on<CreateBudgetEvent>(_onCreateBudget);
//     on<UpdateBudgetEvent>(_onUpdateBudget);
//     on<DeleteBudgetEvent>(_onDeleteBudget);
//     on<LoadBudgetProgress>(_onLoadBudgetProgress);
//     on<LoadAllBudgetProgress>(_onLoadAllBudgetProgress);
//   }
//
//   Future<void> _onLoadBudgets(
//       LoadBudgets event,
//       Emitter<BudgetState> emit,
//       ) async {
//     emit(BudgetLoading());
//     final result = await getBudgets(NoParams());
//     result.fold(
//           (f) => emit(BudgetError(f.message)),
//           (budgets) => emit(BudgetLoaded(budgets)),
//     );
//   }
//
//   Future<void> _onCreateBudget(
//       CreateBudgetEvent event,
//       Emitter<BudgetState> emit,
//       ) async {
//     final result = await createBudget(
//       CreateOrUpdateBudgetParams(budget: event.budget),
//     );
//     result.fold(
//           (f) => emit(BudgetError(f.message)),
//           (_) => add(LoadBudgets()),
//     );
//   }
//
//   Future<void> _onUpdateBudget(
//       UpdateBudgetEvent event,
//       Emitter<BudgetState> emit,
//       ) async {
//     final result = await updateBudget(
//       CreateOrUpdateBudgetParams(budget: event.budget),
//     );
//     result.fold(
//           (f) => emit(BudgetError(f.message)),
//           (_) => add(LoadBudgets()),
//     );
//   }
//
//   Future<void> _onDeleteBudget(
//       DeleteBudgetEvent event,
//       Emitter<BudgetState> emit,
//       ) async {
//     final result = await deleteBudget(IdParams(id: event.budgetId));
//     result.fold(
//           (f) => emit(BudgetError(f.message)),
//           (_) => add(LoadBudgets()),
//     );
//   }
//
//   Future<void> _onLoadBudgetProgress(
//       LoadBudgetProgress event,
//       Emitter<BudgetState> emit,
//       ) async {
//     emit(BudgetLoading());
//     final result = await getBudgetProgress(IdParams(id: event.budgetId));
//     result.fold(
//           (f) => emit(BudgetError(f.message)),
//           (progress) => emit(BudgetProgressLoaded(progress)),
//     );
//   }
//
//   Future<void> _onLoadAllBudgetProgress(
//       LoadAllBudgetProgress event,
//       Emitter<BudgetState> emit,
//       ) async {
//     emit(BudgetLoading());
//     final result = await getAllBudgetProgress(NoParams());
//     result.fold(
//           (f) => emit(BudgetError(f.message)),
//           (progress) => emit(AllBudgetProgressLoaded(progress)),
//     );
//   }
// }
