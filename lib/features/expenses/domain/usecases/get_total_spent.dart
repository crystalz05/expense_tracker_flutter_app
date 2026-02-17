import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';

class GetTotalSpent {
  double call(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }
}
