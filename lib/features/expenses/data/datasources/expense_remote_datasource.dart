
import '../models/expense_model.dart';

abstract class ExpenseRemoteDatasource {

  Future<void> addExpense(ExpenseModel expense, String userId);
  Future<List<ExpenseModel>> getExpenses(String userId);
  Future<void> deleteExpense(String id, String userId);
  Future<void> softDeleteExpense(String id, String userId, DateTime updatedAt);
  Future<void> upsertExpenses(List<ExpenseModel> expenses, String userId);
  Future<void> syncExpenses(List<ExpenseModel> expenses, String userId);
}