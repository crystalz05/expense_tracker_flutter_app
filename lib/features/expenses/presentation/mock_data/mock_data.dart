import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> recentTransactions = [
  {'title': 'Electricity Bill', 'date': DateTime(2025, 2, 4), 'amount': '₦32,400', 'icon': Icons.lightbulb},
  {'title': 'Grocery Shopping', 'date': DateTime(2025, 2, 4), 'amount': '₦18,750', 'icon': Icons.fastfood},
  {'title': 'Movie Night', 'date': DateTime(2025, 2, 5), 'amount': '₦7,200', 'icon': Icons.movie},
  {'title': 'Transport Fare', 'date': DateTime(2025, 2, 2), 'amount': '₦3,800', 'icon': Icons.directions_bus},
  {'title': 'Online Shopping', 'date': DateTime(2025, 2, 2), 'amount': '₦45,999', 'icon': Icons.shopping_bag},
  {'title': 'Restaurant', 'date': DateTime(2025, 2, 1), 'amount': '₦12,300', 'icon': Icons.restaurant},
  {'title': 'Airtime Purchase', 'date': DateTime(2025, 2, 7), 'amount': '₦5,000', 'icon': Icons.phone_android},
  {'title': 'Gym Membership', 'date': DateTime(2025, 2, 4), 'amount': '₦20,000', 'icon': Icons.fitness_center},
  {'title': 'Pharmacy', 'date': DateTime(2025, 2, 2), 'amount': '₦9,450', 'icon': Icons.local_pharmacy},
  {'title': 'Snacks', 'date': DateTime(2025, 2, 6), 'amount': '₦2,150', 'icon': Icons.fastfood},
  {'title': 'Online Subscription', 'date': DateTime(2025, 2, 5), 'amount': '₦3,200', 'icon': Icons.subscriptions},
];

Map<DateTime, List<Map<String, dynamic>>> groupByDay(
    List<Map<String, dynamic>> recentTransactions
    ) {

  final Map<DateTime, List<Map<String, dynamic>>> grouped = {};

  for(final tx in recentTransactions) {
    final DateTime date = tx['date'];

    final day = DateTime(date.year, date.month, date.day);

    grouped.putIfAbsent(day, ()=> []);
    grouped[day]!.add(tx);
  }
  return grouped;
}

Map<DateTime, List<Expense>> groupByDayFinal(
    List<Expense> recentTransactions
    ) {

  final Map<DateTime, List<Expense>> grouped = {};

  for(final tx in recentTransactions) {
    final DateTime date = tx.updatedAt;

    final day = DateTime(date.year, date.month, date.day);

    grouped.putIfAbsent(day, ()=> []);
    grouped[day]!.add(tx);
  }
  return grouped;
}