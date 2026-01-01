import 'package:expenses_tracker_app/core/utils/expenses_categories.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_event.dart';
import 'package:expenses_tracker_app/features/budget/presentation/bloc/budget_state.dart';
import 'package:expenses_tracker_app/features/budget/presentation/pages/add_budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../widgets/add_budget_widgets/amount_field.dart';
import '../widgets/add_budget_widgets/category_grid.dart';
import '../widgets/add_budget_widgets/date_field.dart';
import '../widgets/add_budget_widgets/description_text_field.dart';
import '../widgets/add_budget_widgets/period_selector.dart';
import '../widgets/add_budget_widgets/recurring_toggle.dart';
import '../widgets/add_budget_widgets/section_tile.dart';

class EditBudgetPage extends StatefulWidget {
  final Budget budget;

  const EditBudgetPage({super.key, required this.budget});

  @override
  State<EditBudgetPage> createState() => _EditBudgetPageState();
}

class _EditBudgetPageState extends State<EditBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  late String _selectedCategory;
  late Period _period;
  late bool _isRecurring;
  late double? _alertThreshold;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.budget.amount.toStringAsFixed(2),
    );
    _descriptionController = TextEditingController(
      text: widget.budget.description,
    );
    _selectedCategory = widget.budget.category;
    _period = Period.values.firstWhere(
          (p) => p.name == widget.budget.period,
      orElse: () => Period.monthly,
    );
    _isRecurring = widget.budget.isRecurring;
    _alertThreshold = widget.budget.alertThreshold;
    _startDate = widget.budget.startDate;
    _endDate = widget.budget.endDate;
    _startDateController = TextEditingController(
      text: DateFormat('EEEE, MMMM d, yyyy').format(_startDate),
    );
    _endDateController = TextEditingController(
      text: DateFormat('EEEE, MMMM d, yyyy').format(_endDate),
    );
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
    if (_formKey.currentState!.validate()) {
      final updatedBudget = Budget(
        id: widget.budget.id,
        userId: widget.budget.userId,
        category: _selectedCategory,
        description: _descriptionController.text.trim(),
        amount: double.parse(_amountController.text),
        startDate: _startDate,
        endDate: _endDate,
        period: _period.name,
        isRecurring: _isRecurring,
        alertThreshold: _alertThreshold,
        createdAt: widget.budget.createdAt,
        updatedAt: DateTime.now(),
        isDeleted: widget.budget.isDeleted,
      );

      context.read<BudgetBloc>().add(UpdateBudgetEvent(updatedBudget));
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = ExpenseCategories.fromName(_selectedCategory);

    return BlocListener<BudgetBloc, BudgetState>(
      listener: (context, state) {
        if (state is BudgetOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(state.message),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
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
              backgroundColor: categoryData.color,
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
                        categoryData.color,
                        categoryData.color.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.edit_note,
                        size: 48,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Edit Budget',
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
                                      _startDateController.text =
                                          DateFormat('EEEE, MMMM d, yyyy').format(date);
                                      if (_endDate.isBefore(_startDate)) {
                                        _endDate = _startDate;
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
                                      _endDateController.text =
                                          DateFormat('EEEE, MMMM d, yyyy').format(date);
                                    });
                                  },
                                  firstDate: _startDate,
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
                                  onPressed: isLoading ? null : () => context.pop(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FilledButton(
                                  onPressed: isLoading ? null : _submitForm,
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                      : const Text('Save Changes'),
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

