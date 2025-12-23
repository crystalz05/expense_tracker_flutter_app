import 'package:flutter/material.dart';

class ExpenseCategory {
  final String name;
  final IconData icon;
  final Color color;

  const ExpenseCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class ExpenseCategories {
  static const food = ExpenseCategory(
    name: 'Food & Dining',
    icon: Icons.restaurant,
    color: Colors.orange,
  );

  static const transportation = ExpenseCategory(
    name: 'Transportation',
    icon: Icons.directions_car,
    color: Colors.blue,
  );

  static const shopping = ExpenseCategory(
    name: 'Shopping',
    icon: Icons.shopping_bag,
    color: Colors.purple,
  );

  static const entertainment = ExpenseCategory(
    name: 'Entertainment',
    icon: Icons.movie,
    color: Colors.redAccent,
  );

  static const bills = ExpenseCategory(
    name: 'Bills & Utilities',
    icon: Icons.receipt_long,
    color: Colors.teal,
  );

  static const health = ExpenseCategory(
    name: 'Health',
    icon: Icons.favorite,
    color: Colors.green,
  );

  static const others = ExpenseCategory(
    name: 'Others',
    icon: Icons.category,
    color: Colors.grey,
  );

  static const List<ExpenseCategory> all = [
    food,
    transportation,
    shopping,
    entertainment,
    bills,
    health,
    others,
  ];

  static ExpenseCategory fromName(String name) {
    return ExpenseCategories.all.firstWhere(
          (c) => c.name == name,
      orElse: () => ExpenseCategories.others,
    );
  }

}
