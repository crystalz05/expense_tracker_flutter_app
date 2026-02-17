import 'dart:convert';
import 'package:expenses_tracker_app/core/constants/supabase_constants.dart';
import 'package:expenses_tracker_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/expense_model.dart';
import 'expense_remote_datasource.dart';

class ExpenseRemoteDatasourceImpl implements ExpenseRemoteDatasource {
  final SupabaseClient supabase;

  ExpenseRemoteDatasourceImpl(this.supabase);

  @override
  Future<void> addExpense(ExpenseModel expense, String userId) async {
    try {
      await supabase.from(SupabaseConstants.expensesTable).upsert({
        'id': expense.id,
        'user_id': userId,
        'amount': expense.amount,
        'category': expense.category,
        'description': expense.description,
        'payment_method': expense.paymentMethod,
        'is_deleted': expense.isDeleted,
        'created_at': expense.createdAt.toIso8601String(),
        'updated_at': expense.updatedAt.toIso8601String(),
      });
    } catch (e) {
      throw ServerException("Failed to add expense: $e");
    }
  }

  @override
  Future<void> softDeleteExpense(
    String id,
    String userId,
    DateTime updatedAt,
  ) async {
    try {
      await supabase
          .from(SupabaseConstants.expensesTable)
          .update({
            'is_deleted': true,
            'updated_at': updatedAt.toIso8601String(),
          })
          .eq('id', id)
          .eq('user_id', userId);
    } catch (e) {
      throw ServerException("Failed to soft-delete expense: $e");
    }
  }

  @override
  Future<void> deleteExpense(String id, String userId) async {
    try {
      await supabase
          .from(SupabaseConstants.expensesTable)
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
    } catch (e) {
      throw ServerException("Failed to hard-delete expense: $e");
    }
  }

  @override
  Future<List<ExpenseModel>> getExpenses(String userId) async {
    try {
      final response = await supabase
          .from(SupabaseConstants.expensesTable)
          .select()
          .eq('user_id', userId)
          .eq('is_deleted', false)
          .order('updated_at', ascending: false);

      return (response as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .map(
            (json) => ExpenseModel(
              id: json['id'],
              amount: json['amount'],
              category: json['category'],
              description: json['description'],
              createdAt: DateTime.parse(json['created_at']),
              updatedAt: DateTime.parse(json['updated_at']),
              paymentMethod: json['payment_method'],
              isDeleted: json['is_deleted'] ?? false,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException("Failed to fetch expenses: $e");
    }
  }

  @override
  Future<void> upsertExpenses(
    List<ExpenseModel> expenses,
    String userId,
  ) async {
    try {
      final data = expenses
          .map(
            (expense) => {
              'id': expense.id,
              'user_id': userId,
              'amount': expense.amount,
              'category': expense.category,
              'description': expense.description,
              'payment_method': expense.paymentMethod,
              'is_deleted': expense.isDeleted,
              'created_at': expense.createdAt.toIso8601String(),
              'updated_at': expense.updatedAt.toIso8601String(),
            },
          )
          .toList();

      await supabase
          .from(SupabaseConstants.expensesTable)
          .upsert(data, onConflict: 'id');
    } catch (e) {
      throw ServerException("Failed to upsert expenses: $e");
    }
  }

  @override
  Future<List<ExpenseModel>> getAllExpensesIncludingDeleted(
    String userId,
  ) async {
    try {
      final response = await supabase
          .from(SupabaseConstants.expensesTable)
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      return (response as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .map(
            (json) => ExpenseModel(
              id: json['id'],
              amount: json['amount'],
              category: json['category'],
              description: json['description'],
              createdAt: DateTime.parse(json['created_at']),
              updatedAt: DateTime.parse(json['updated_at']),
              paymentMethod: json['payment_method'],
              isDeleted: json['is_deleted'] ?? false,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException("Failed to fetch all expenses: $e");
    }
  }
}
