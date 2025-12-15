

import 'package:expenses_tracker_app/features/expenses/data/entities/expense_entity.dart';

import '../../domain/entities/expense.dart';

extension ExpenseModelMapper on ExpenseEntity {
  Expense toEntity() {
    return Expense(
      id: id,
      amount: amount,
      category: category,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      paymentMethod: paymentMethod,
    );
  }
}

extension ExpenseEntityMapper on Expense {
  ExpenseEntity toModel() {
    return ExpenseEntity(
      id: id,
      amount: amount,
      category: category,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      paymentMethod: paymentMethod,
    );
  }
}