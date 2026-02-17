import 'package:equatable/equatable.dart';

class CategorySpending extends Equatable {
  final String category;
  final double amount;
  final double percentage;
  final int transactionCount;

  const CategorySpending({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.transactionCount,
  });

  @override
  List<Object?> get props => [category, amount, percentage, transactionCount];
}
