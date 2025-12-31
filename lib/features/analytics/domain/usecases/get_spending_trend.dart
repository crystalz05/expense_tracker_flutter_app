import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/spending_trend.dart';
import '../repositories/analytics_repository.dart';

class GetSpendingTrend implements UseCase<SpendingTrend, TrendParams> {
  final AnalyticsRepository repository;

  GetSpendingTrend(this.repository);

  @override
  Future<Either<Failure, SpendingTrend>> call(TrendParams params) {
    return repository.getSpendingTrend(monthsBack: params.monthsBack);
  }
}