import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/monthly_comparison.dart';
import '../repositories/analytics_repository.dart';

class GetMonthlyComparison implements UseCase<MonthlyComparison?, MonthComparisonParams> {
  final AnalyticsRepository repository;

  GetMonthlyComparison(this.repository);

  @override
  Future<Either<Failure, MonthlyComparison?>> call(MonthComparisonParams params) {
    return repository.getMonthlyComparison(
      currentMonth: params.currentMonth,
      previousMonth: params.previousMonth,
    );
  }
}

