import 'package:expenses_tracker_app/core/utils/expenses_categories.dart';
import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_event.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_state.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../widgets/add_budget_widgets/amount_field.dart';
import '../widgets/add_budget_widgets/category_grid.dart';
import '../widgets/add_budget_widgets/date_field.dart';
import '../widgets/add_budget_widgets/description_text_field.dart';
import '../widgets/add_budget_widgets/period_selector.dart';
import '../widgets/add_budget_widgets/recurring_toggle.dart';
import '../widgets/add_budget_widgets/section_tile.dart';

// Period enum (if not already defined in add_budget.dart)
enum Period { weekly, monthly, yearly }

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  String? _selectedCategory;
  Period _period = Period.monthly;
  bool _isRecurring = false;
  double? _alertThreshold = 80.0;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _startDateController.text = DateFormat('MMM d, yyyy').format(_startDate!);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) return;

      final budget = Budget(
        id: const Uuid().v4(),
        userId: authState.user.id,
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        amount: double.parse(_amountController.text),
        startDate: _startDate!,
        endDate: _endDate!,
        period: _period.name,
        isRecurring: _isRecurring,
        alertThreshold: _alertThreshold,
        createdAt: DateTime.now(),
      );

      context.read<BudgetBloc>().add(CreateBudgetEvent(budget));
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetBloc, BudgetState>(
      listener: (context, state) {
        if (state is BudgetOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Budget created successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop(true);
        } else if (state is BudgetError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 150,
              pinned: true,
              backgroundColor: Color(0xFF0A2E5D),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0A2E5D),
                        Color(0xFF0A2E5D).withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.add_circle_outline,
                        size: 48,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create Budget',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(title: 'Description'),
                      const SizedBox(height: 12),
                      DescriptionField(controller: _descriptionController),
                      const SizedBox(height: 24),
                      SectionTitle(title: 'Budget Amount'),
                      const SizedBox(height: 12),
                      AmountField(controller: _amountController),
                      const SizedBox(height: 24),
                      SectionTitle(title: 'Category'),
                      const SizedBox(height: 12),
                      CategoryGrid(
                        selectedCategory: _selectedCategory,
                        onCategoryChanged: (category) {
                          setState(() => _selectedCategory = category);
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SectionTitle(title: 'Start Date'),
                                const SizedBox(height: 12),
                                DateField(
                                  controller: _startDateController,
                                  selectedDate: _startDate,
                                  onDateSelected: (date) {
                                    setState(() {
                                      _startDate = date;
                                      _startDateController.text = DateFormat(
                                        'MMM d, yyyy',
                                      ).format(date);
                                      if (_endDate != null &&
                                          _endDate!.isBefore(_startDate!)) {
                                        _endDate = null;
                                        _endDateController.clear();
                                      }
                                    });
                                  },
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SectionTitle(title: 'End Date'),
                                const SizedBox(height: 12),
                                DateField(
                                  controller: _endDateController,
                                  selectedDate: _endDate,
                                  onDateSelected: (date) {
                                    setState(() {
                                      _endDate = date;
                                      _endDateController.text = DateFormat(
                                        'MMM d, yyyy',
                                      ).format(date);
                                    });
                                  },
                                  firstDate: _startDate ?? DateTime.now(),
                                  lastDate: DateTime(2100),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SectionTitle(title: 'Period'),
                      const SizedBox(height: 12),
                      PeriodSelector(
                        selectedPeriod: _period,
                        onPeriodChanged: (period) {
                          setState(() => _period = period);
                        },
                      ),
                      const SizedBox(height: 24),
                      RecurringToggle(
                        isRecurring: _isRecurring,
                        onChanged: (value) {
                          setState(() => _isRecurring = value);
                        },
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<BudgetBloc, BudgetState>(
                        builder: (context, state) {
                          final isLoading = state is BudgetLoading;
                          return Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => context.pop(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FilledButton(
                                  onPressed: isLoading ? null : _submitForm,
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text('Create Budget'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
