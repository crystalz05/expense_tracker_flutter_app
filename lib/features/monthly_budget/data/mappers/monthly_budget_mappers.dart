import '../../domain/entities/monthly_budget.dart';
import '../models/monthly_budget_model.dart';

extension MonthlyBudgetModelMapper on MonthlyBudgetModel {
  MonthlyBudget toEntity() {
    return MonthlyBudget(
      id: id,
      userId: userId,
      month: month,
      year: year,
      amount: amount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
      needsSync: needsSync,
      lastSyncedAt: lastSyncedAt,
    );
  }
}

extension MonthlyBudgetEntityMapper on MonthlyBudget {
  MonthlyBudgetModel toModel() {
    return MonthlyBudgetModel(
      id: id,
      userId: userId,
      month: month,
      year: year,
      amount: amount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
      needsSync: needsSync,
      lastSyncedAt: lastSyncedAt,
    );
  }
}
