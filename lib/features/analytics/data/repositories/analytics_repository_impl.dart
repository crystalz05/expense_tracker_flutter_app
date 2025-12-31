import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../../../budget/domain/repositories/budget_repository.dart';
import '../../domain/entities/analytics_summary.dart';
import '../../domain/entities/category_comparison.dart';
import '../../domain/entities/category_spending.dart';
import '../../domain/entities/monthly_comparison.dart';
import '../../domain/entities/monthly_spending.dart';
import '../../domain/entities/spending_insight.dart';
import '../../domain/entities/spending_trend.dart';
import '../../domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final ExpenseRepository expenseRepository;
  final BudgetRepository budgetRepository;

  AnalyticsRepositoryImpl({
    required this.expenseRepository,
    required this.budgetRepository,
  });

  @override
  Future<Either<Failure, List<CategorySpending>>> getCategorySpending({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final expensesResult = await expenseRepository.getExpensesByDateRange(
        startDate,
        endDate,
      );

      return expensesResult.fold(
            (failure) => Left(failure),
            (expenses) {
          final categoryMap = <String, _CategoryData>{};
          double total = 0;

          for (final expense in expenses) {
            if (!categoryMap.containsKey(expense.category)) {
              categoryMap[expense.category] = _CategoryData();
            }
            categoryMap[expense.category]!.amount += expense.amount;
            categoryMap[expense.category]!.count++;
            total += expense.amount;
          }

          final categorySpending = categoryMap.entries.map((entry) {
            return CategorySpending(
              category: entry.key,
              amount: entry.value.amount,
              percentage: total > 0 ? (entry.value.amount / total) * 100 : 0,
              transactionCount: entry.value.count,
            );
          }).toList();

          categorySpending.sort((a, b) => b.amount.compareTo(a.amount));

          return Right(categorySpending);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure('Failed to get category spending: $e'));
    }
  }

  @override
  Future<Either<Failure, MonthlyComparison?>> getMonthlyComparison({
    required DateTime currentMonth,
    required DateTime previousMonth,
  }) async {
    try {
      final currentStart = DateTime(currentMonth.year, currentMonth.month, 1);
      final currentEnd = DateTime(currentMonth.year, currentMonth.month + 1, 0);

      final previousStart = DateTime(previousMonth.year, previousMonth.month, 1);
      final previousEnd = DateTime(previousMonth.year, previousMonth.month + 1, 0);

      final currentExpensesResult = await expenseRepository.getExpensesByDateRange(
        currentStart,
        currentEnd,
      );

      final previousExpensesResult = await expenseRepository.getExpensesByDateRange(
        previousStart,
        previousEnd,
      );

      return currentExpensesResult.fold(
            (failure) => Left(failure),
            (currentExpenses) {
          return previousExpensesResult.fold(
                (failure) => Left(failure),
                (previousExpenses) {
              double currentTotal = 0;
              double previousTotal = 0;

              final currentCategoryMap = <String, double>{};
              final previousCategoryMap = <String, double>{};

              for (final expense in currentExpenses) {
                currentTotal += expense.amount;
                currentCategoryMap[expense.category] =
                    (currentCategoryMap[expense.category] ?? 0) + expense.amount;
              }

              for (final expense in previousExpenses) {
                previousTotal += expense.amount;
                previousCategoryMap[expense.category] =
                    (previousCategoryMap[expense.category] ?? 0) + expense.amount;
              }

              final allCategories = {
                ...currentCategoryMap.keys,
                ...previousCategoryMap.keys,
              };

              final categoryComparisons = <String, CategoryComparison>{};

              for (final category in allCategories) {
                final currentAmount = currentCategoryMap[category] ?? 0;
                final previousAmount = previousCategoryMap[category] ?? 0;

                double percentageChange = 0;
                if (previousAmount > 0) {
                  percentageChange = ((currentAmount - previousAmount) / previousAmount) * 100;
                } else if (currentAmount > 0) {
                  percentageChange = 100;
                }

                categoryComparisons[category] = CategoryComparison(
                  category: category,
                  currentAmount: currentAmount,
                  previousAmount: previousAmount,
                  percentageChange: percentageChange.abs(),
                  isIncrease: currentAmount >= previousAmount,
                );
              }

              double totalPercentageChange = 0;
              if (previousTotal > 0) {
                totalPercentageChange = ((currentTotal - previousTotal) / previousTotal) * 100;
              } else if (currentTotal > 0) {
                totalPercentageChange = 100;
              }

              return Right(MonthlyComparison(
                currentMonth: currentMonth,
                previousMonth: previousMonth,
                currentTotal: currentTotal,
                previousTotal: previousTotal,
                percentageChange: totalPercentageChange.abs(),
                isIncrease: currentTotal >= previousTotal,
                categoryComparisons: categoryComparisons,
              ));
            },
          );
        },
      );
    } catch (e) {
      return Left(DatabaseFailure('Failed to get monthly comparison: $e'));
    }
  }

  @override
  Future<Either<Failure, List<SpendingInsight>>> getSpendingInsights({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final insights = <SpendingInsight>[];
      final uuid = const Uuid();

      // Get current period expenses
      final expensesResult = await expenseRepository.getExpensesByDateRange(
        startDate,
        endDate,
      );

      if (expensesResult.isLeft()) {
        return expensesResult.fold((f) => Left(f), (_) => const Right([]));
      }

      final expenses = expensesResult.getOrElse(() => []);

      // Get budgets
      final budgetsResult = await budgetRepository.getBudgets();

      if (budgetsResult.isRight()) {
        final budgets = budgetsResult.getOrElse(() => []);

        // Check budget exceeded insights
        for (final budget in budgets) {
          if (budget.isDeleted) continue;

          final categoryExpenses = expenses.where(
                (e) => e.category == budget.category &&
                e.createdAt.isAfter(budget.startDate) &&
                e.createdAt.isBefore(budget.endDate),
          );

          final totalSpent = categoryExpenses.fold<double>(
            0,
                (sum, e) => sum + e.amount,
          );

          final percentageUsed = (totalSpent / budget.amount) * 100;

          if (totalSpent > budget.amount) {
            final exceeded = totalSpent - budget.amount;
            final exceededPercent = ((exceeded / budget.amount) * 100);

            insights.add(SpendingInsight(
              id: uuid.v4(),
              type: InsightType.budgetExceeded,
              category: budget.category,
              message: '${budget.category} exceeded budget by ${exceededPercent.toStringAsFixed(1)}%',
              description: 'You spent ₦${totalSpent.toStringAsFixed(2)} out of ₦${budget.amount.toStringAsFixed(2)}',
              severity: InsightSeverity.critical,
              amount: exceeded,
              percentage: exceededPercent,
              generatedAt: DateTime.now(),
            ));
          } else if (percentageUsed >= (budget.alertThreshold ?? 80)) {
            insights.add(SpendingInsight(
              id: uuid.v4(),
              type: InsightType.budgetWarning,
              category: budget.category,
              message: '${budget.category} is at ${percentageUsed.toStringAsFixed(1)}% of budget',
              description: 'You have ₦${(budget.amount - totalSpent).toStringAsFixed(2)} remaining',
              severity: InsightSeverity.warning,
              percentage: percentageUsed,
              generatedAt: DateTime.now(),
            ));
          }
        }
      }

      // Get previous period for comparison
      final duration = endDate.difference(startDate);
      final previousStart = startDate.subtract(duration);
      final previousEnd = startDate.subtract(const Duration(days: 1));

      final previousExpensesResult = await expenseRepository.getExpensesByDateRange(
        previousStart,
        previousEnd,
      );

      if (previousExpensesResult.isRight()) {
        final previousExpenses = previousExpensesResult.getOrElse(() => []);

        // Category spending comparison
        final currentCategoryMap = <String, double>{};
        final previousCategoryMap = <String, double>{};

        for (final expense in expenses) {
          currentCategoryMap[expense.category] =
              (currentCategoryMap[expense.category] ?? 0) + expense.amount;
        }

        for (final expense in previousExpenses) {
          previousCategoryMap[expense.category] =
              (previousCategoryMap[expense.category] ?? 0) + expense.amount;
        }

        // Check for significant increases
        for (final entry in currentCategoryMap.entries) {
          final category = entry.key;
          final currentAmount = entry.value;
          final previousAmount = previousCategoryMap[category] ?? 0;

          if (previousAmount > 0) {
            final percentageChange = ((currentAmount - previousAmount) / previousAmount) * 100;

            if (percentageChange > 20) {
              insights.add(SpendingInsight(
                id: uuid.v4(),
                type: InsightType.spendingIncrease,
                category: category,
                message: '$category spending increased by ${percentageChange.toStringAsFixed(1)}%',
                description: 'You spent ₦${currentAmount.toStringAsFixed(2)} vs ₦${previousAmount.toStringAsFixed(2)} last period',
                severity: InsightSeverity.warning,
                percentage: percentageChange,
                generatedAt: DateTime.now(),
              ));
            } else if (percentageChange < -20) {
              insights.add(SpendingInsight(
                id: uuid.v4(),
                type: InsightType.spendingDecrease,
                category: category,
                message: '$category spending decreased by ${percentageChange.abs().toStringAsFixed(1)}%',
                description: 'You spent ₦${currentAmount.toStringAsFixed(2)} vs ₦${previousAmount.toStringAsFixed(2)} last period',
                severity: InsightSeverity.info,
                percentage: percentageChange.abs(),
                generatedAt: DateTime.now(),
              ));
            }
          }
        }

        // Check if one category dominates spending
        final totalCurrent = currentCategoryMap.values.fold<double>(0, (a, b) => a + b);
        if (totalCurrent > 0) {
          for (final entry in currentCategoryMap.entries) {
            final percentage = (entry.value / totalCurrent) * 100;
            if (percentage > 40) {
              insights.add(SpendingInsight(
                id: uuid.v4(),
                type: InsightType.categoryDominating,
                category: entry.key,
                message: '${entry.key} accounts for ${percentage.toStringAsFixed(1)}% of spending',
                description: 'Consider reviewing your ${entry.key} expenses',
                severity: InsightSeverity.info,
                percentage: percentage,
                generatedAt: DateTime.now(),
              ));
            }
          }
        }
      }

      // Sort by severity
      insights.sort((a, b) {
        final severityOrder = {
          InsightSeverity.critical: 0,
          InsightSeverity.warning: 1,
          InsightSeverity.info: 2,
        };
        return severityOrder[a.severity]!.compareTo(severityOrder[b.severity]!);
      });

      return Right(insights);
    } catch (e) {
      return Left(DatabaseFailure('Failed to generate insights: $e'));
    }
  }

  @override
  Future<Either<Failure, SpendingTrend>> getSpendingTrend({
    required int monthsBack,
  }) async {
    try {
      final now = DateTime.now();
      final monthlyData = <MonthlySpending>[];
      final categoryTotals = <String, double>{};

      for (int i = 0; i < monthsBack; i++) {
        final month = DateTime(now.year, now.month - i, 1);
        final startDate = DateTime(month.year, month.month, 1);
        final endDate = DateTime(month.year, month.month + 1, 0);

        final expensesResult = await expenseRepository.getExpensesByDateRange(
          startDate,
          endDate,
        );

        final expenses = expensesResult.getOrElse(() => []);
        final monthTotal = expenses.fold<double>(0, (sum, e) => sum + e.amount);

        monthlyData.add(MonthlySpending(month: month, amount: monthTotal));

        for (final expense in expenses) {
          categoryTotals[expense.category] =
              (categoryTotals[expense.category] ?? 0) + expense.amount;
        }
      }

      monthlyData.sort((a, b) => a.month.compareTo(b.month));

      final topCategory = categoryTotals.entries.isEmpty
          ? 'None'
          : categoryTotals.entries.reduce((a, b) => a.value > b.value ? a : b).key;

      final averageMonthlySpending = monthlyData.isEmpty
          ? 0.0
          : monthlyData.fold<double>(0, (sum, m) => sum + m.amount) / monthlyData.length;

      // Determine trend
      TrendDirection trend = TrendDirection.stable;
      if (monthlyData.length >= 2) {
        final recentAvg = monthlyData.skip(monthlyData.length - 2).fold<double>(0, (sum, m) => sum + m.amount) / 2;
        final olderAvg = monthlyData.take(2).fold<double>(0, (sum, m) => sum + m.amount) / 2;

        if (olderAvg > 0) {
          final change = ((recentAvg - olderAvg) / olderAvg) * 100;
          if (change > 10) {
            trend = TrendDirection.increasing;
          } else if (change < -10) {
            trend = TrendDirection.decreasing;
          }
        }
      }

      return Right(SpendingTrend(
        monthlyData: monthlyData,
        topCategory: topCategory,
        averageMonthlySpending: averageMonthlySpending,
        overallTrend: trend,
      ));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get spending trend: $e'));
    }
  }

  @override
  Future<Either<Failure, AnalyticsSummary>> getAnalyticsSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final categorySpendingResult = await getCategorySpending(
        startDate: startDate,
        endDate: endDate,
      );

      final insightsResult = await getSpendingInsights(
        startDate: startDate,
        endDate: endDate,
      );

      final trendResult = await getSpendingTrend(monthsBack: 6);

      return categorySpendingResult.fold(
            (failure) => Left(failure),
            (categorySpending) {
          return insightsResult.fold(
                (failure) => Left(failure),
                (insights) {
              return trendResult.fold(
                    (failure) => Left(failure),
                    (trend) async {
                  final totalSpending = categorySpending.fold<double>(
                    0,
                        (sum, c) => sum + c.amount,
                  );

                  MonthlyComparison? monthComparison;

                  final now = DateTime.now();
                  final currentMonth = DateTime(now.year, now.month, 1);
                  final previousMonth = DateTime(now.year, now.month - 1, 1);

                  final comparisonResult = await getMonthlyComparison(
                    currentMonth: currentMonth,
                    previousMonth: previousMonth,
                  );

                  monthComparison = comparisonResult.getOrElse(() => null);

                  return Right(AnalyticsSummary(
                    periodStart: startDate,
                    periodEnd: endDate,
                    totalSpending: totalSpending,
                    categoryBreakdown: categorySpending,
                    monthComparison: monthComparison,
                    insights: insights,
                    trend: trend,
                  ));
                },
              );
            },
          );
        },
      );
    } catch (e) {
      return Left(DatabaseFailure('Failed to get analytics summary: $e'));
    }
  }
}

class _CategoryData {
  double amount = 0;
  int count = 0;
}