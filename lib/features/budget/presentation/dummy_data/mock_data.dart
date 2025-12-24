

import '../../domain/entities/budget.dart';

final List<Budget> budgets = [
  Budget(
    id: 1,
    category: 'Food & Dining',
    amount: 50000.0,
    startDate: DateTime(2025, 12, 1),
    endDate: DateTime(2025, 12, 31),
    period: 'monthly',
    isRecurring: true,
    alertThreshold: 80.0,
  ),
  Budget(
    id: 2,
    category: 'Transportation',
    amount: 20000.0,
    startDate: DateTime(2025, 12, 1),
    endDate: DateTime(2025, 12, 31),
    period: 'monthly',
    isRecurring: true,
    alertThreshold: 75.0,
  ),
  Budget(
    id: 3,
    category: 'Entertainment',
    amount: 15000.0,
    startDate: DateTime(2025, 12, 1),
    endDate: DateTime(2025, 12, 31),
    period: 'monthly',
    isRecurring: true,
    alertThreshold: 90.0,
  ),
];