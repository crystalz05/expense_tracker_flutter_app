import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/budget_model.dart';
import 'budget_remote_datasource.dart';

class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final SupabaseClient client;

  BudgetRemoteDataSourceImpl(this.client);

  @override
  Future<List<BudgetModel>> getBudgets(String userId) async {
    final response = await client
        .from('budgets')
        .select()
        .eq('user_id', userId)
        .eq('is_deleted', false);

    return (response as List)
        .map((json) => BudgetModel.fromJson(json))
        .toList();
  }

  @override
  Future<BudgetModel?> getBudgetById(String id) async {
    final response = await client
        .from('budgets')
        .select()
        .eq('id', id)
        .maybeSingle();

    return response != null ? BudgetModel.fromJson(response) : null;
  }

  @override
  Future<void> createBudget(BudgetModel budget) async {
    await client
        .from('budgets')
        .insert(budget.toJson());
  }

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    await client
        .from('budgets')
        .update(budget.toJson())
        .eq('id', budget.id);
  }

  @override
  Future<void> deleteBudget(String id) async {
    // Soft delete - just mark as deleted
    await client
        .from('budgets')
        .update({'is_deleted': true})
        .eq('id', id);
  }

  @override
  Future<void> permanentlyDeleteBudgets(List<String> ids) async {
    // Hard delete from database
    await client
        .from('budgets')
        .delete()
        .inFilter('id', ids);
  }

  @override
  Future<List<BudgetModel>> getBudgetsModifiedAfter(DateTime timestamp, String userId) async {
    final response = await client
        .from('budgets')
        .select()
        .eq('user_id', userId)
        .gte('created_at', timestamp.toIso8601String());

    return (response as List)
        .map((json) => BudgetModel.fromJson(json))
        .toList();
  }
}