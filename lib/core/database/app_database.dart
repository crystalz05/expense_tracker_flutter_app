
import 'package:expenses_tracker_app/core/utils/date_time_converter.dart';
import 'package:expenses_tracker_app/features/expenses/data/datasources/expense_dao.dart';
import 'package:floor/floor.dart';


import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../features/expenses/data/models/expense_model.dart';

part 'app_database.g.dart';


@TypeConverters([DateTimeConverter])
@Database(version: 2, entities: [ExpenseModel])
abstract class AppDatabase extends FloorDatabase {
  ExpenseDao get expenseDao;
}