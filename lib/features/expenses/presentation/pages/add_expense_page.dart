
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_state.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/add_expense_categories_widget.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/date_picker_field.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/dropdown_menu_widget.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/widgets/top_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<StatefulWidget> createState() => _AddExpensePage();
}

class _AddExpensePage extends State<AddExpensePage>{

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  String? _paymentMethod;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitExpense(){
    if(_formKey.currentState!.validate()){
      final expense = ExpenseParams(
        amount: double.parse(_amountController.text),
        category: _selectedCategory ?? "Food & Dining",
        description: _descriptionController.text,
        paymentMethod: _paymentMethod ?? "",
      );
      context.read<ExpenseBloc>().add(AddExpenseEvent(expense));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state){
          if(state is ExpenseActionSuccess){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green)
            );
          }else if (state is ExpenseError){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red)
            );
          }
        },
        child: SingleChildScrollView(
            child: Padding(padding: EdgeInsetsGeometry.all(16),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Add Expense", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text("Record a new transaction", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey)),
                        SizedBox(height: 24),
                        Text("Amount (NGN)", style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 8,),
                        TextFormField(
                          controller: _amountController,
                          maxLines: 1,
                          keyboardType: TextInputType.numberWithOptions(),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                          ],
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter an amount' : null,
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
                          controller: _descriptionController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: "What did you spend on?",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text("Payment Method", style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 8,),
                        DropdownMenuWidget(paymentMethodSelected: (method){
                          setState(() {
                            _paymentMethod = method;
                          });
                        },),
                        SizedBox(height: 24),
                        Text("Category", style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 8),
                        AddExpenseCategoriesWidget(onCategorySelected: (category){
                          setState(() {
                            _selectedCategory = category;
                          });
                        },),
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
                              onPressed: (){
                                _submitExpense();
                              },
                              child: Text("Add Expense")),
                        )
                      ],
                    )
                )
            )
        )
    );
  }
}