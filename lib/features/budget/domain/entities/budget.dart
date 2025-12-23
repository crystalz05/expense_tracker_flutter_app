
import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final int? id;
  final String category;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final String period; // 'monthly', 'weekly', 'yearly'
  final bool isRecurring;
  final double? alertThreshold; // Percentage to trigger alert (e.g., 80%)

  const Budget({
    this.id,
    required this.category,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.period,
    this.isRecurring = true,
    this.alertThreshold = 80.0,
  });

  @override
  List<Object?> get props => [
    id,
    category,
    amount,
    startDate,
    endDate,
    period,
    isRecurring,
    alertThreshold,
  ];
}