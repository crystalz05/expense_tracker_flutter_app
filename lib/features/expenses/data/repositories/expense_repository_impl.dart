

import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/exceptions.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/features/expenses/data/datasources/expenses_local_datasource.dart';
import 'package:expenses_tracker_app/features/expenses/data/mappers/expense_mappers.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {

  final ExpensesLocalDatasource localDatasource;

  ExpenseRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, void>> addExpense(Expense expense) async {
    try{
      final model = expense.toModel();
      await localDatasource.addExpense(model);
      return const Right(null);
    } on DatabaseException catch (e){
      return Left(DatabaseFailure(e.message));
    } catch (e){
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async {
    try{
      await localDatasource.deleteExpense(id);
      return const Right(null);
    } on DatabaseException catch (e){
      return Left(DatabaseFailure(e.message));
    } catch (e){
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Expense>> getExpenseById(String id) async {
    try{
      final model = await localDatasource.getExpenseById(id);
      if(model == null){
        return Left(DatabaseFailure("Expense not found"));
      }
      final entity = model.toEntity();
      return Right(entity);
    } on DatabaseException catch (e){
      return Left(DatabaseFailure(e.message));
    } catch (e){
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpenses() async {

    try{
      final models = await localDatasource.getExpenses();
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e){
      return Left(DatabaseFailure(e.message));
    } catch (e){
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(Expense expense) async {
    try{
      final model = expense.toModel();
      await localDatasource.updateExpense(model);
      return const Right(null);
    } on DatabaseException catch (e){
      return Left(DatabaseFailure(e.message));
    } catch (e){
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpenseByCategory(String category) async {
    try {
      final models = await localDatasource.getExpenseByCategory(category);
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e){
      return Left(DatabaseFailure(e.message));
    } catch (e){
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(DateTime start, DateTime end) async {
    try {
      final models = await localDatasource.getExpensesByDateRange(start, end);
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e){
      return Left(DatabaseFailure(e.message));
    } catch (e){
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

}