import '../../domain/entities/budget.dart';
import '../models/budget_model.dart';

extension BudgetModelMapper on BudgetModel {
  Budget toEntity() {
    return Budget(
      id: id,
      userId: userId,
      category: category,
      description: description,
      amount: amount,
      startDate: startDate,
      endDate: endDate,
      period: period,
      isRecurring: isRecurring,
      alertThreshold: alertThreshold,
      createdAt: createdAt,
    );
  }
}

extension BudgetEntityMapper on Budget {
  BudgetModel toModel() {
    return BudgetModel(
      id: id,
      userId: userId,
      category: category,
      description: description,
      amount: amount,
      startDate: startDate,
      endDate: endDate,
      period: period,
      isRecurring: isRecurring,
      alertThreshold: alertThreshold,
      createdAt: createdAt,
    );
  }
}
