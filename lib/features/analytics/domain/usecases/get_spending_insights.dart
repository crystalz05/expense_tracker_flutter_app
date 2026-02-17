import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/spending_insight.dart';
import '../repositories/analytics_repository.dart';

class GetSpendingInsights
    implements UseCase<List<SpendingInsight>, DateRangeParams> {
  final AnalyticsRepository repository;

  GetSpendingInsights(this.repository);

  @override
  Future<Either<Failure, List<SpendingInsight>>> call(DateRangeParams params) {
    return repository.getSpendingInsights(
      startDate: params.start,
      endDate: params.end,
    );
  }
}
