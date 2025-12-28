import 'package:floor/floor.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/budget.dart';

@Entity(tableName: 'budgets')
class BudgetModel {
  @primaryKey
  final String id;

  final String userId;
  final String category;
  final String description;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final String period;
  final bool isRecurring;
  final double? alertThreshold;
  final DateTime createdAt;

  const BudgetModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.description,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.period,
    required this.isRecurring,
    this.alertThreshold,
    required this.createdAt,
  });

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
      alertThreshold: (json['alert_threshold'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
