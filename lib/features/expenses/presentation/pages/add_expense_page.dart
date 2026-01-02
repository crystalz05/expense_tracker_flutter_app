
// ==================== REFACTORED ADD EXPENSE PAGE ====================
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/format_date.dart';
import '../widgets/add_edit_expense_widgets/category_selector.dart';
import '../widgets/add_edit_expense_widgets/expense_amount_field.dart';
import '../widgets/add_edit_expense_widgets/expense_description_field.dart';
import '../widgets/add_edit_expense_widgets/expense_form_header.dart';
import '../widgets/add_edit_expense_widgets/expense_submit_button.dart';
import '../widgets/add_edit_expense_widgets/payment_method_selector.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<StatefulWidget> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = "Food & Dining";
  String _paymentMethod = "Card";

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitExpense() {
    if (_formKey.currentState!.validate()) {
      final expense = ExpenseParams(
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        description: _descriptionController.text,
        paymentMethod: _paymentMethod,
      );
      context.read<ExpenseBloc>().add(AddExpenseEvent(expense));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseActionSuccess) {
          _showSuccessSnackBar(context, state.message);
          context.pop(true);
        } else if (state is ExpenseError) {
          _showErrorSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Expense",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ExpenseFormHeader(
                      subtitle: "Record a new transaction",
                    ),
                    const SizedBox(height: 32),
                    ExpenseAmountField(controller: _amountController),
                    const SizedBox(height: 24),
                    ExpenseDescriptionField(controller: _descriptionController),
                    const SizedBox(height: 24),
                    PaymentMethodSelector(
                      selectedMethod: _paymentMethod,
                      onMethodSelected: (method) {
                        setState(() => _paymentMethod = method);
                      },
                    ),
                    const SizedBox(height: 28),
                    CategorySelector(
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() => _selectedCategory = category);
                      },
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<ExpenseBloc, ExpenseState>(
                      builder: (context, state) {
                        return ExpenseSubmitButton(
                          onPressed: _submitExpense,
                          isLoading: state is ExpenseLoading,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}