
import 'package:floor/floor.dart';

import '../../../../core/utils/date_time_converter.dart';

@TypeConverters([DateTimeConverter, NullableDateTimeConverter])
@Entity(tableName: 'expenses')
class ExpenseModel {

  @primaryKey
  final String id;

  final double amount;
  final String category;
  final String? description;

  @ColumnInfo(name: 'created_at')
  final DateTime createdAt;

  @ColumnInfo(name: 'updated_at')
  final DateTime updatedAt;

  @ColumnInfo(name: 'payment_method')
  final String paymentMethod;

  @ColumnInfo(name: 'is_deleted')
  final bool isDeleted;

  const ExpenseModel({
    required this.id,
    required this.amount,
    required this.category,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentMethod,
    required this.isDeleted
  });
}