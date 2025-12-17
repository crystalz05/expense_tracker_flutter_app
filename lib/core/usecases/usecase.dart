
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:uuid/uuid.dart';

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

  const IdParams({required this.id});

  @override
  List<Object?> get props => [id];
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