
import 'package:hive/hive.dart';
part 'expense_model.g.dart';


@HiveType(typeId: 0)
class ExpenseModel extends HiveObject {

  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final String paymentMethod ;

  ExpenseModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentMethod
  });

}