import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final String? id;
  final String userId; // Track which user owns this budget
  final String category;
  final String description;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final String period; // 'monthly', 'weekly', 'yearly'
  final bool isRecurring;
  final double? alertThreshold; // Percentage to trigger alert (e.g., 80%)
  final DateTime createdAt;

  const Budget({
    this.id,
    required this.userId,
    required this.category,
    required this.description,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.period,
    this.isRecurring = true,
    this.alertThreshold = 80.0,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    category,
    description,
    amount,
    startDate,
    endDate,
    period,
    isRecurring,
    alertThreshold,
    createdAt,
  ];
}