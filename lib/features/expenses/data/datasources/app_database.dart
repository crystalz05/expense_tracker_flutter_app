
import 'package:expenses_tracker_app/core/utils/date_time_converter.dart';
import 'package:expenses_tracker_app/features/expenses/data/datasources/expense_dao.dart';
import 'package:floor/floor.dart';

import '../entities/expense_entity.dart';



import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';


@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [ExpenseEntity])
abstract class AppDatabase extends FloorDatabase {
  ExpenseDao get expenseDao;
}