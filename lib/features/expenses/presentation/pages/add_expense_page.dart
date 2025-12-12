
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/add_expense_categories_widget.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/date_picker_field.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/top_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(padding: EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Expense", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text("Record a new transaction", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey)),
                SizedBox(height: 24),
                Text("Amount (NGN)", style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 8,),
                TextField(
                  maxLines: 1,
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                  ],
                  decoration: InputDecoration(
                    hintText: "0.00",
                    prefixText: "₦ ",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text("Description", style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 8,),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "What did you spend on?",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text("Date", style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 8,),
                DatePickerField(),
                SizedBox(height: 24),
                Text("Category", style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 8),
                AddExpenseCategoriesWidget(),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onPrimary) ,
                          elevation: WidgetStatePropertyAll(0),
                          padding: WidgetStatePropertyAll(EdgeInsetsGeometry.symmetric(vertical: 18)),
                          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                          shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))
                          ) ),
                      onPressed: (){},
                      child: Text("Add Expense")),
                )
              ],
            )
        )
    );
  }
}