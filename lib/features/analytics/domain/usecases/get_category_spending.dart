import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category_spending.dart';
import '../repositories/analytics_repository.dart';

class GetCategorySpending
    implements UseCase<List<CategorySpending>, DateRangeParams> {
  final AnalyticsRepository repository;

  GetCategorySpending(this.repository);

  @override
  Future<Either<Failure, List<CategorySpending>>> call(DateRangeParams params) {
    return repository.getCategorySpending(
      startDate: params.start,
      endDate: params.end,
    );
  }
}
