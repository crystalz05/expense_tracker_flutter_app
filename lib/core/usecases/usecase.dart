
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../features/monthly_budget/domain/entities/monthly_budget.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params param);
}

class NoParams extends Equatable{
  @override
  List<Object?> get props => [];
}

class IdParams extends Equatable {

  final String id;
  final DateTime updatedAt;

  IdParams({
    required this.id,
    DateTime? updatedAt
  }): updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [id, updatedAt];
}

class ExpenseParams extends Equatable{

  final double amount;
  final String category;
  final String? description;
  final String paymentMethod;

  const ExpenseParams({
    required this.amount,
    required this.category,
    this.description,
    required this.paymentMethod,
  });

  factory ExpenseParams.fromExpense(Expense expense){
    return ExpenseParams(
        amount: expense.amount,
        category: expense.category,
        description: expense.description,
        paymentMethod: expense.paymentMethod
    );
  }

  @override
  List<Object?> get props => [amount, category, description, paymentMethod];
}

class CategoryParams extends Equatable {
  final String category;

  const CategoryParams(this.category);

  @override
  List<Object?> get props => [category];
}

class CategoryDateRangeParams extends Equatable {
  final String category;
  final DateTime start;
  final DateTime end;

  const CategoryDateRangeParams({
    required this.category,
    required this.start,
    required this.end,
  });

  @override
  List<Object?> get props => [start, end];
}

class DateRangeParams extends Equatable {
  final DateTime start;
  final DateTime end;

  const DateRangeParams({
    required this.start,
    required this.end,
  });

  @override
  List<Object?> get props => [start, end];
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String? displayName;

  const SignUpParams({
    required this.email,
    required this.password,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

class CreateOrUpdateBudgetParams extends Equatable {
  final Budget budget;

  const CreateOrUpdateBudgetParams({
    required this.budget,
  });

  @override
  List<Object?> get props => [budget];
}

class MonthComparisonParams extends Equatable {
  final DateTime currentMonth;
  final DateTime previousMonth;

  const MonthComparisonParams({
    required this.currentMonth,
    required this.previousMonth,
  });

  @override
  List<Object?> get props => [currentMonth, previousMonth];
}

class TrendParams extends Equatable {
  final int monthsBack;

  const TrendParams({required this.monthsBack});

  @override
  List<Object?> get props => [monthsBack];
}

class MonthYearParams extends Equatable {
  final int month;
  final int year;

  const MonthYearParams({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}

class YearParams extends Equatable {
  final int year;

  const YearParams({required this.year});

  @override
  List<Object?> get props => [year];
}

class MonthlyBudgetParams extends Equatable {
  final MonthlyBudget monthlyBudget;

  const MonthlyBudgetParams({required this.monthlyBudget});

  @override
  List<Object?> get props => [monthlyBudget];
}