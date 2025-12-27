import 'package:floor/floor.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/budget.dart';

@Entity(tableName: 'budgets')
class BudgetModel extends Budget {
  @override
  @primaryKey
  final String? id;

  @override
  final String userId;

  const BudgetModel({
    this.id,
    required this.userId,
    required String category,
    required String description,
    required double amount,
    required DateTime startDate,
    required DateTime endDate,
    required String period,
    bool isRecurring = true,
    double? alertThreshold = 80.0,
    required DateTime createdAt,
  }) : super(
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

  factory BudgetModel.fromEntity(Budget budget) {
    return BudgetModel(
      id: budget.id ?? const Uuid().v4(), // Generate UUID if null
      userId: budget.userId,
      category: budget.category,
      description: budget.description,
      amount: budget.amount,
      startDate: budget.startDate,
      endDate: budget.endDate,
      period: budget.period,
      isRecurring: budget.isRecurring,
      alertThreshold: budget.alertThreshold,
      createdAt: budget.createdAt,
    );
  }

  // For Supabase sync
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category': category,
      'description': description,
      'amount': amount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'period': period,
      'is_recurring': isRecurring,
      'alert_threshold': alertThreshold,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'],
      userId: json['user_id'],
      category: json['category'],
      description: json['description'],
      amount: (json['amount'] as num).toDouble(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      period: json['period'],
      isRecurring: json['is_recurring'] ?? true,
      alertThreshold: (json['alert_threshold'] as num?)?.toDouble() ?? 80.0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}