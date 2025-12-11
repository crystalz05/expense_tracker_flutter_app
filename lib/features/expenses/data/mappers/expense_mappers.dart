

import '../../domain/entities/expense.dart';
import '../models/expense_model.dart';

extension ExpenseModelMapper on ExpenseModel {
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
  ExpenseModel toModel() {
    return ExpenseModel(
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