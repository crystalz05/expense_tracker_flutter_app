
import 'dart:core';

import 'package:floor/floor.dart';

@Entity(tableName: "monthly_budgets")
class MonthlyBudgetModel {


  @primaryKey
  @ColumnInfo(name: 'id')
  final String id;

  @ColumnInfo(name: 'user_id')
  final String userId;

  @ColumnInfo(name: 'month')
  final String month;

  @ColumnInfo(name: 'year')
  final String year;

  @ColumnInfo(name: 'amount')
  final double amount;

  // Sync tracking fields
  @ColumnInfo(name: 'needs_sync')
  final bool needsSync;

  @ColumnInfo(name: 'last_synced_at')
  final DateTime? lastSyncedAt;

  MonthlyBudgetModel({
    required this.id,
    required this.userId,
    required this.month,
    required this.year,
    required this.amount,
    this.needsSync = true,
    this.lastSyncedAt,
  });

    Map<String, dynamic> toJson(){
      return {
        'id': id,
        'user_id': userId,
        'month': month,
        'year': year,
        'amount': amount,
        'needs_sync': needsSync,
        'last_synced_at': lastSyncedAt?.toIso8601String()
      };
    }
  // 'last_synced_at': lastSyncedAt?.toIso8601String(),


  factory MonthlyBudgetModel.fromJson(Map<String, dynamic> json){
      return MonthlyBudgetModel(
          id: json['id'],
          userId: json['userId'],
          month: json['month'],
          year: json['year'],
          amount: json['amount'],
          needsSync: json['need_sync'],
          lastSyncedAt: json['last_synced_at'] != null ? DateTime.parse(json['last_synced_at'])
      );
    }

    MonthlyBudgetModel copyWith({

      String? id,
      String? userId,
      String? month,
      String? year,
      double? amount,
      bool? needSync,
      DateTime lastSyncedAt
    }){
      return MonthlyBudgetModel(
          id: id ?? this.id,
          userId: userId ?? this.userId,
          month: month ?? this.month,
          year: year ?? this.year,
          amount: amount?? this.amount,
          needsSync: needSync ?? this.needsSync,
          lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt
      );
    }
}