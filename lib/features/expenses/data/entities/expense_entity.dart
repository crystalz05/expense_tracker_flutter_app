
import 'package:floor/floor.dart';

@Entity(tableName: 'expenses')
class ExpenseEntity {

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
  final String paymentMethod ;

  const ExpenseEntity({
    required this.id,
    required this.amount,
    required this.category,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentMethod
  });

}