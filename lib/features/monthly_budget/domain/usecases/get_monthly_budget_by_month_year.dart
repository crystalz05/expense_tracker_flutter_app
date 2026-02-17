import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/monthly_budget.dart';
import '../repositories/monthly_budget_repository.dart';

class GetMonthlyBudgetByMonthYear
    implements UseCase<MonthlyBudget?, MonthYearParams> {
  final MonthlyBudgetRepository repository;

  GetMonthlyBudgetByMonthYear(this.repository);

  @override
  Future<Either<Failure, MonthlyBudget?>> call(MonthYearParams params) async {
    return await repository.getMonthlyBudgetByMonthYear(
      params.month,
      params.year,
    );
  }
}
