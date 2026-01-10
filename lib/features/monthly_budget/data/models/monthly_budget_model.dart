import 'package:floor/floor.dart';

import '../../../../core/utils/date_time_converter.dart';

@TypeConverters([DateTimeConverter, NullableDateTimeConverter])
@Entity(tableName: 'monthly_budgets')
class MonthlyBudgetModel {
  @primaryKey
  @ColumnInfo(name: 'id')
  final String id;

  @ColumnInfo(name: 'user_id')
  final String userId;

  @ColumnInfo(name: 'month')
  final int month; // 1-12

  @ColumnInfo(name: 'year')
  final int year;

  @ColumnInfo(name: 'amount')
  final double amount;

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

  const MonthlyBudgetModel({
    required this.id,
    required this.userId,
    required this.month,
    required this.year,
    required this.amount,
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
      'month': month,
      'year': year,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_deleted': isDeleted,
      'needs_sync': needsSync,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
    };
  }

  factory MonthlyBudgetModel.fromJson(Map<String, dynamic> json) {
    return MonthlyBudgetModel(
      id: json['id'],
      userId: json['user_id'],
      month: json['month'] as int,
      year: json['year'] as int,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      isDeleted: json['is_deleted'] ?? false,
      needsSync: json['needs_sync'] ?? false,
      lastSyncedAt: json['last_synced_at'] != null ? DateTime.parse(json['last_synced_at']) : null,
    );
  }

  MonthlyBudgetModel copyWith({
    String? id,
    String? userId,
    int? month,
    int? year,
    double? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    bool? needsSync,
    DateTime? lastSyncedAt,
  }) {
    return MonthlyBudgetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      month: month ?? this.month,
      year: year ?? this.year,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      needsSync: needsSync ?? this.needsSync,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}