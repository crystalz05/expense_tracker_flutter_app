import 'package:get_it/get_it.dart';
import 'data/repositories/analytics_repository_impl.dart';
import 'domain/repositories/analytics_repository.dart';
import 'domain/usecases/get_analytics_summary.dart';
import 'domain/usecases/get_category_spending.dart';
import 'domain/usecases/get_monthly_comparison.dart';
import 'domain/usecases/get_spending_insights.dart';
import 'domain/usecases/get_spending_trend.dart';
import 'presentation/bloc/analytics_bloc.dart';

Future<void> initAnalytics(GetIt sl) async {
  // Repository
  sl.registerLazySingleton<AnalyticsRepository>(
        () => AnalyticsRepositoryImpl(
      expenseRepository: sl(),
      budgetRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCategorySpending(sl()));
  sl.registerLazySingleton(() => GetMonthlyComparison(sl()));
  sl.registerLazySingleton(() => GetSpendingInsights(sl()));
  sl.registerLazySingleton(() => GetSpendingTrend(sl()));
  sl.registerLazySingleton(() => GetAnalyticsSummary(sl()));

  // Bloc
  sl.registerFactory(
        () => AnalyticsBloc(
      getCategorySpending: sl(),
      getMonthlyComparison: sl(),
      getSpendingInsights: sl(),
      getSpendingTrend: sl(),
      getAnalyticsSummary: sl(),
    ),
  );
}