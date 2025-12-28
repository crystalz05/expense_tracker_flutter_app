

import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/exceptions.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/network/network_info.dart';
import 'package:expenses_tracker_app/features/expenses/data/datasources/expense_remote_datasource.dart';
import 'package:expenses_tracker_app/features/expenses/data/datasources/expenses_local_datasource.dart';
import 'package:expenses_tracker_app/features/expenses/data/mappers/expense_mappers.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';

import '../../../auth/domain/user_session/user_session.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {

  final ExpensesLocalDatasource localDatasource;
  final ExpenseRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  final UserSession userSession;

  ExpenseRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
    required this.userSession
  });

  @override
  Future<Either<Failure, void>> addExpense(Expense expense) async {
    try{
      final model = expense.toModel();
      await localDatasource.addExpense(model);
      if(await networkInfo.isConnected){
        try{
          await remoteDatasource.addExpense(
              model,
              userSession.userId);
        }catch (_) {}
      }
      return const Right(null);
    } on DatabaseException catch (e){
      return Left(DatabaseFailure(e.message));
    } catch (e){
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(Expense expense) async {
    try{
      final model = expense.toModel();
      await localDatasource.updateExpense(model);

      if(await networkInfo.isConnected){
        try {
          await remoteDatasource.addExpense(
              model,
              userSession.userId
          );
        }catch (_) {}
      }
      return const Right(null);
    } on DatabaseException catch (e){
      return Left(DatabaseFailure(e.message));
    } catch (e){
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> softDeleteExpense(String id, DateTime updatedAt) async {
    try{
      await localDatasource.softDeleteExpense(id, updatedAt);
      if(await networkInfo.isConnected){
        try {
          await remoteDatasource.softDeleteExpense(id, userSession.userId, updatedAt);
        }catch (_) {}
      }
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

      if(await networkInfo.isConnected){
        try {
          await remoteDatasource.deleteExpense(id, userSession.userId);
        }catch (_){}
      }

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



  @override
  Future<Either<Failure, void>> syncExpenses() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      // Fetch local expenses
      final localExpenses = await localDatasource.getExpenses();

      // Get userId
      final userId = userSession.userId;

      // Sync with remote via upsert
      await remoteDatasource.upsertExpenses(localExpenses, userId);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getByCategoryAndPeriod(String category, DateTime start, DateTime end) async {
    try {
      final models = await localDatasource.getByCategoryAndPeriod(category, start, end);
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e){
      return Left(DatabaseFailure(e.message));
    } catch (e){
      return Left(DatabaseFailure('Unexpected error: ${e.toString()}'));
    }
  }
}