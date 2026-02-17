import 'package:equatable/equatable.dart';

class MonthlySpending extends Equatable {
  final DateTime month;
  final double amount;

  const MonthlySpending({required this.month, required this.amount});

  @override
  List<Object?> get props => [month, amount];
}

enum TrendDirection { increasing, decreasing, stable }
