import 'package:equatable/equatable.dart';

class MonthlyBudget extends Equatable {
  final String id;
  final String userId;
  final int month; // 1-12
  final int year;
  final double amount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;
  final bool needsSync;
  final DateTime? lastSyncedAt;

  const MonthlyBudget({
    required this.id,
    required this.userId,
    required this.month,
    required this.year,
    required this.amount,
    required this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
    this.needsSync = false,
    this.lastSyncedAt,
  });

  String get monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  // Helper to get short month name
  String get shortMonthName {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    month,
    year,
    amount,
    createdAt,
    updatedAt,
    isDeleted,
    needsSync,
    lastSyncedAt,
  ];
}
