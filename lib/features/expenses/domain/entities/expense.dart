
import 'package:equatable/equatable.dart';

class Expense extends Equatable {

  final String id;
  final double amount;
  final String category;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String paymentMethod;
  final bool isDeleted;

  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentMethod,
    this.isDeleted = false
  });

  // Expense copyWith({
  //   String? id,
  //   double? amount,
  //   String? category,
  //   String? description,
  //   DateTime? createdAt,
  //   DateTime? updatedAt,
  //   required String paymentMethod,
  //   bool? isDeleted
  // }){
  //   return Expense(
  //       id: id ?? this.id,
  //       amount: amount ?? this.amount,
  //       category: category ?? this.category,
  //       description: description ?? this.description,
  //       createdAt: createdAt ?? this.createdAt,
  //       updatedAt: updatedAt ?? this.updatedAt,
  //       paymentMethod: paymentMethod,
  //       isDeleted: isDeleted ?? this.isDeleted
  //   );
  // }

  @override
  List<Object?> get props => [id, amount, category, description, createdAt, updatedAt, paymentMethod, isDeleted];

}