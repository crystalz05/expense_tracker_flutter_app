import 'package:floor/floor.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/date_time_converter.dart';

@TypeConverters([DateTimeConverter, NullableDateTimeConverter])
@Entity(tableName: 'budgets')
class BudgetModel {
  @primaryKey
  @ColumnInfo(name: 'id')
  final String id;

  @ColumnInfo(name: 'user_id')
  final String userId;

  @ColumnInfo(name: 'category')
  final String category;

  @ColumnInfo(name: 'description')
  final String description;

  @ColumnInfo(name: 'amount')
  final double amount;

  @ColumnInfo(name: 'start_date')
  final DateTime startDate;

  @ColumnInfo(name: 'end_date')
  final DateTime endDate;

  @ColumnInfo(name: 'period')
  final String period;

  @ColumnInfo(name: 'is_recurring')
  final bool isRecurring;

  @ColumnInfo(name: 'alert_threshold')
  final double? alertThreshold;

  @ColumnInfo(name: 'created_at')
  final DateTime createdAt;

  @ColumnInfo(name: 'updated_at')
  final DateTime? updatedAt;

  @ColumnInfo(name: 'is_deleted')
  final bool isDeleted;

  // Sync tracking fields
  @ColumnInfo(name: 'needs_sync')
  final bool needsSync;

  @ColumnInfo(name: 'last_synced_at')
  final DateTime? lastSyncedAt;

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
    this.updatedAt,
    required this.isDeleted,
    this.needsSync = true,
    this.lastSyncedAt,
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
      'updated_at': updatedAt?.toIso8601String(),
      'is_deleted': isDeleted,
      'needs_sync': needsSync,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
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
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      isDeleted: json['is_deleted'] ?? false,
      needsSync: json['needs_sync'] ?? false,
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'])
          : null,
    );
  }

  BudgetModel copyWith({
    String? id,
    String? userId,
    String? category,
    String? description,
    double? amount,
    DateTime? startDate,
    DateTime? endDate,
    String? period,
    bool? isRecurring,
    double? alertThreshold,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    bool? needsSync,
    DateTime? lastSyncedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      period: period ?? this.period,
      isRecurring: isRecurring ?? this.isRecurring,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      needsSync: needsSync ?? this.needsSync,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}
