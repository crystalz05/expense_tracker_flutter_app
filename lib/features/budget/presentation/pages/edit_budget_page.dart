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
                      _SectionTitle(title: 'Description'),
                      const SizedBox(height: 12),
                      _DescriptionField(controller: _descriptionController),
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'Budget Amount'),
                      const SizedBox(height: 12),
                      _AmountField(controller: _amountController),
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'Category'),
                      const SizedBox(height: 12),
                      _CategoryGrid(
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
                                _SectionTitle(title: 'Start Date'),
                                const SizedBox(height: 12),
                                _DateField(
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
                                _SectionTitle(title: 'End Date'),
                                const SizedBox(height: 12),
                                _DateField(
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
                      _SectionTitle(title: 'Period'),
                      const SizedBox(height: 12),
                      _PeriodSelector(
                        selectedPeriod: _period,
                        onPeriodChanged: (period) {
                          setState(() => _period = period);
                        },
                      ),
                      const SizedBox(height: 24),
                      _RecurringToggle(
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


// ==================== HELPER WIDGETS FOR BUDGET FORMS ====================
// Add these to your edit_budget_page.dart or create a separate widgets file

// ==================== SECTION TITLE ====================
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// ==================== AMOUNT FIELD ====================
class _AmountField extends StatelessWidget {
  final TextEditingController controller;

  const _AmountField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          prefixText: '₦ ',
          prefixStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          hintText: '0.00',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an amount';
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
      ),
    );
  }
}

// ==================== DESCRIPTION FIELD ====================
class _DescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const _DescriptionField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: 'e.g., Monthly Groceries',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          prefixIcon: Icon(
            Icons.description_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a description';
          }
          return null;
        },
      ),
    );
  }
}

// ==================== CATEGORY GRID ====================
class _CategoryGrid extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const _CategoryGrid({
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ExpenseCategories.all;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.category_outlined,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Select Category',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          if (selectedCategory != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Selected: $selectedCategory',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category.name;

              return InkWell(
                onTap: () => onCategoryChanged(category.name),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? category.color.withOpacity(0.15)
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? category.color
                          : Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category.icon,
                        color: isSelected
                            ? category.color
                            : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                        size: 28,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? category.color : null,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ==================== DATE FIELD ====================
class _DateField extends StatelessWidget {
  final TextEditingController controller;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime firstDate;
  final DateTime lastDate;

  const _DateField({
    required this.controller,
    required this.selectedDate,
    required this.onDateSelected,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Pick a date',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          prefixIcon: Icon(
            Icons.calendar_today,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a date';
          }
          return null;
        },
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? firstDate,
            firstDate: firstDate,
            lastDate: lastDate,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme,
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            onDateSelected(picked);
          }
        },
      ),
    );
  }
}

// ==================== PERIOD SELECTOR ====================
class _PeriodSelector extends StatelessWidget {
  final Period selectedPeriod;
  final ValueChanged<Period> onPeriodChanged;

  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.loop,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Budget Period',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: Period.values.map((period) {
              final isSelected = selectedPeriod == period;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => onPeriodChanged(period),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _getPeriodIcon(period),
                            size: 24,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            period.label,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getPeriodIcon(Period period) {
    switch (period) {
      case Period.weekly:
        return Icons.view_week;
      case Period.monthly:
        return Icons.calendar_month;
      case Period.yearly:
        return Icons.calendar_today;
    }
  }
}

// ==================== RECURRING TOGGLE ====================
class _RecurringToggle extends StatelessWidget {
  final bool isRecurring;
  final ValueChanged<bool> onChanged;

  const _RecurringToggle({
    required this.isRecurring,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isRecurring
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.repeat,
              color: isRecurring
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recurring Budget',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Automatically renew this budget',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isRecurring,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

// ==================== INFO CARD (Optional Enhancement) ====================
class _InfoCard extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.message,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}