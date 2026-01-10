import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/monthly_budget_model.dart';
import 'monthly_budget_remote_datasource.dart';

class MonthlyBudgetRemoteDataSourceImpl implements MonthlyBudgetRemoteDataSource {
  final SupabaseClient client;
  static const String tableName = 'monthly_budgets';

  MonthlyBudgetRemoteDataSourceImpl(this.client);

  @override
  Future<List<MonthlyBudgetModel>> getMonthlyBudgets(String userId) async {
    final response = await client
        .from(tableName)
        .select()
        .eq('user_id', userId)
        .eq('is_deleted', false)
        .order('year', ascending: false)
        .order('month', ascending: false);

    return (response as List)
        .map((json) => MonthlyBudgetModel.fromJson(json))
        .toList();
  }

  @override
  Future<MonthlyBudgetModel?> getMonthlyBudgetById(String id) async {
    final response = await client
        .from(tableName)
        .select()
        .eq('id', id)
        .maybeSingle();

    return response != null ? MonthlyBudgetModel.fromJson(response) : null;
  }

  @override
  Future<MonthlyBudgetModel?> getMonthlyBudgetByMonthYear(String userId, int month, int year) async {
    final response = await client
        .from(tableName)
        .select()
        .eq('user_id', userId)
        .eq('month', month)
        .eq('year', year)
        .eq('is_deleted', false)
        .maybeSingle();

    return response != null ? MonthlyBudgetModel.fromJson(response) : null;
  }

  @override
  Future<void> createMonthlyBudget(MonthlyBudgetModel monthlyBudget) async {
    await client
        .from(tableName)
        .insert(monthlyBudget.toJson());
  }

  @override
  Future<void> updateMonthlyBudget(MonthlyBudgetModel monthlyBudget) async {
    await client
        .from(tableName)
        .update(monthlyBudget.toJson())
        .eq('id', monthlyBudget.id);
  }

  @override
  Future<void> deleteMonthlyBudget(String id) async {
    // Soft delete - mark as deleted
    await client
        .from(tableName)
        .update({'is_deleted': true, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }

  @override
  Future<void> permanentlyDeleteMonthlyBudgets(List<String> ids) async {
    // Hard delete from database
    await client
        .from(tableName)
        .delete()
        .inFilter('id', ids);
  }
}