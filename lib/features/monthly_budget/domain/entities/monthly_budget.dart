
import 'package:equatable/equatable.dart';

class MonthlyBudget extends Equatable {

  final String id;
  final String userId;
  final String month;
  final String year;
  final double amount;
  final bool needsSync;
  final DateTime? lastSyncedAt;

  const MonthlyBudget({
    required this.id,
    required this.userId,
    required this.month,
    required this.year,
    required this.amount,
    this.needsSync = false,
    this.lastSyncedAt,

  });

  @override
  List<Object?> get props => [id, userId, month, year, amount, needsSync, lastSyncedAt];
}

