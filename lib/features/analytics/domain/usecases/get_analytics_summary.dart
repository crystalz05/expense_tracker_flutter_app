import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/analytics_summary.dart';
import '../repositories/analytics_repository.dart';

class GetAnalyticsSummary
    implements UseCase<AnalyticsSummary, DateRangeParams> {
  final AnalyticsRepository repository;

  GetAnalyticsSummary(this.repository);

  @override
  Future<Either<Failure, AnalyticsSummary>> call(DateRangeParams params) {
    return repository.getAnalyticsSummary(
      startDate: params.start,
      endDate: params.end,
    );
  }
}
