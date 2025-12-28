import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_state.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/add_budget_category_grid_widget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/buttons_widget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/period_drop_down_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../expenses/presentation/widgets/dropdown_menu_widget.dart';
import '../../domain/entities/budget.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({super.key});

  @override
  State<StatefulWidget> createState() => _AddBudgetState();

}

class _AddBudgetState extends State<AddBudget> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _budgetAmountController = TextEditingController();
  final TextEditingController _budgetDescriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DateTime? endDate;
  bool isRecurring = false;
  String? _selectedCategory;
  DateTime? startDate;
  Period _period = Period.monthly;
  double? _alertThreshold;

  @override void dispose() {
    _budgetAmountController.dispose();
    _budgetDescriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    _startDateController.text = DateFormat('EEEE, MMMM d, yyyy').format(startDate!);
  }

  void _submitBudget() {
    if (_formKey.currentState!.validate()) {
      // Validate category selection
      if (_selectedCategory == null || _selectedCategory!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      // Get userId from AuthBloc
      final authState = context.read<AuthBloc>().state;

      if (authState is! AuthAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to create a budget')),
        );
        return;
      }

      final now = DateTime.now();
      final budget = Budget(
        id: const Uuid().v4(),
        userId: authState.user.id,
        description: _budgetDescriptionController.text.trim(),
        amount: double.parse(_budgetAmountController.text),
        category: _selectedCategory!,
        startDate: startDate!,
        endDate: endDate!,
        period: _period.name,
        isRecurring: isRecurring,
        alertThreshold: _alertThreshold ?? 80.0,
        createdAt: now,
      );
      context.read<BudgetBloc>().add(CreateBudgetEvent(budget));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetBloc, BudgetState>(
        listener: (context, state){
          if(state is BudgetError){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red)
            );
          }else if (state is BudgetLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Budget created successfully!')),
            );
            context.pop();
          }
        },
        child: Scaffold(
            appBar: AppBar(
                title: const Text("Add Budget"),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => context.pop(),
                )
            ),
            body: BlocBuilder<BudgetBloc, BudgetState>(
                builder: (context, state){
                  final isLoading = state is BudgetLoading;

                  return Stack(
                    children: [
                      SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Create a budget to track your spending in a specific category",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                                  Divider(thickness: 0.5,),
                                  SizedBox(height: 16,),

                                  // Budget Description
                                  Text("Budget Description", style: Theme.of(context).textTheme.bodyMedium),
                                  SizedBox(height: 8,),
                                  TextFormField(
                                    controller: _budgetDescriptionController,
                                    maxLines: 1,
                                    validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null ,

                                    decoration: InputDecoration(
                                      hintText: "e.g., Monthly Groceries?",
                                      hintStyle: TextStyle(fontWeight: FontWeight.w200),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    textCapitalization: TextCapitalization.sentences,
                                  ),
                                  SizedBox(height: 24,),

                                  // Budget Amount
                                  Text("Budget Amount (₦)", style: Theme.of(context).textTheme.bodyMedium),
                                  SizedBox(height: 8,),
                                  TextFormField(
                                    controller: _budgetAmountController,
                                    maxLines: 1,
                                    keyboardType: TextInputType.numberWithOptions(),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                                    ],
                                    validator: (value) {
                                      if(value == null || value.isEmpty){
                                        return "Please enter an amount";
                                      }
                                      final amount = double.tryParse(value);
                                      if (amount == null || amount <= 0) {
                                        return 'Please enter a valid amount';
                                      }
                                      final decimalPart = value.split('.');
                                      if (decimalPart.length == 2 && decimalPart[1].length > 2) {
                                        return 'Amount cannot have more than 2 decimal places';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "0.00",
                                      hintStyle: TextStyle(fontWeight: FontWeight.w200),
                                      prefixText: "₦ ",
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24,),

                                  // Categories
                                  Text("Categories", style: Theme.of(context).textTheme.bodyMedium),
                                  AddBudgetCategoryGridWidget(onCategorySelected: (category){
                                    setState(() {
                                      _selectedCategory = category.name;
                                    });
                                  },),
                                  if (_selectedCategory != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        "Selected: $_selectedCategory",
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 24,),

                                  // Start Date
                                  Text("Start Date", style: Theme.of(context).textTheme.bodyMedium),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _startDateController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: "Pick a date",
                                      hintStyle: const TextStyle(fontWeight: FontWeight.w200),
                                      prefixIcon: const Icon(Icons.calendar_today_sharp, size: 18),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onTap: () async {
                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: startDate ?? DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        setState(() {
                                          startDate = pickedDate;
                                          _startDateController.text =
                                              DateFormat('EEEE, MMMM d, yyyy').format(pickedDate);

                                          // Clear end date if it's before start date
                                          if (endDate != null && endDate!.isBefore(startDate!)) {
                                            endDate = null;
                                            _endDateController.clear();
                                          }
                                        });
                                      }
                                    },
                                  ),
                                  SizedBox(height: 24),

                                  // End Date
                                  Text("End Date",style: Theme.of(context).textTheme.bodyMedium),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _endDateController,
                                    validator: (value) {
                                      if(value == null || value.isEmpty){
                                        return "Please pick an end date";
                                      }
                                    },
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: "Pick a date",
                                      hintStyle: const TextStyle(fontWeight: FontWeight.w200),
                                      prefixIcon: const Icon(Icons.calendar_today_sharp, size: 18),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onTap: () async {
                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: endDate ?? startDate?.add(const Duration(days: 30)) ?? DateTime.now(),
                                        firstDate: startDate ?? DateTime.now(),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        setState(() {
                                          endDate = pickedDate;
                                          _endDateController.text =
                                              DateFormat('EEEE, MMMM d, yyyy').format(pickedDate);
                                        });
                                      }
                                    },
                                  ),
                                  SizedBox(height: 24,),

                                  // Period
                                  Text("Period", style: Theme.of(context).textTheme.bodyMedium),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    child: PeriodDropDownMenu<Period>(
                                      width: double.infinity,
                                      items: Period.values,
                                      initialValue: Period.monthly,
                                      labelBuilder: (p) => p.label,
                                      onSelected: (period) {
                                        setState(() {
                                          _period = period;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 24,),

                                  // Recurring checkbox
                                  Row(
                                    children: [
                                      Checkbox(value: isRecurring, onChanged: (recurring) {
                                        setState(() {
                                          isRecurring = recurring ?? false;
                                        });
                                      }),
                                      Text("Make this a recurring budget")
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(child: ButtonsWidget(
                                          textColor: Theme.of(context).colorScheme.onError,
                                          color: Theme.of(context).colorScheme.error,
                                          buttonName: "Cancel",
                                          onPressed: () {context.pop();})),
                                      SizedBox(width: 24),
                                      Expanded(child: ButtonsWidget(
                                          buttonName: "Add Budget",
                                          onPressed: () {
                                            isLoading ? null : _submitBudget();
                                          }
                                      )
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24)
                                ],
                              ),
                            ),

                          )
                      ),
                      if (isLoading)
                        Container(
                          color: Colors.black26,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  );
                }
            )
        )
    );
  }
}


enum Period {
  weekly,
  monthly,
  yearly,
}

extension PeriodX on Period {
  String get label {
    switch (this) {
      case Period.weekly:
        return 'Weekly';
      case Period.monthly:
        return 'Monthly';
      case Period.yearly:
        return 'Yearly';
    }
  }
}