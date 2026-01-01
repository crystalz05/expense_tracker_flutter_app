import 'package:expenses_tracker_app/core/utils/expenses_categories.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditExpensePage extends StatefulWidget {
  final Expense expense;

  const EditExpensePage({super.key, required this.expense});

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;

  late String _selectedCategory;
  late String _selectedPaymentMethod;
  late DateTime _selectedDate;

  final List<String> _paymentMethods = [
    'Cash',
    'Card',
    'Bank Transfer',
    'Mobile Money',
    'Other'
  ];

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(
      text: widget.expense.amount.toStringAsFixed(2),
    );
    _descriptionController = TextEditingController(
      text: widget.expense.description ?? '',
    );
    _selectedCategory = widget.expense.category;
    _selectedPaymentMethod = widget.expense.paymentMethod;
    _selectedDate = widget.expense.createdAt;
    _dateController = TextEditingController(
      text: DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedExpense = Expense(
        id: widget.expense.id,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        createdAt: _selectedDate,
        updatedAt: DateTime.now(),
        paymentMethod: _selectedPaymentMethod,
        isDeleted: widget.expense.isDeleted,
      );

      context.read<ExpenseBloc>().add(UpdateExpenseEvent(updatedExpense));
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = ExpenseCategories.fromName(_selectedCategory);

    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseActionSuccess) {
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
        } else if (state is ExpenseError) {
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
            // Modern App Bar
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
                        Icons.edit,
                        size: 48,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Edit Transaction',
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

            // Form Content
            SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Amount Field
                      _SectionTitle(title: 'Amount'),
                      const SizedBox(height: 12),
                      _AmountField(controller: _amountController),

                      const SizedBox(height: 24),

                      // Category Selection
                      _SectionTitle(title: 'Category'),
                      const SizedBox(height: 12),
                      _CategoryGrid(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() => _selectedCategory = category);
                        },
                      ),

                      const SizedBox(height: 24),

                      // Description Field
                      _SectionTitle(title: 'Description'),
                      const SizedBox(height: 12),
                      _DescriptionField(controller: _descriptionController),

                      const SizedBox(height: 24),

                      // Payment Method
                      _SectionTitle(title: 'Payment Method'),
                      const SizedBox(height: 12),
                      _PaymentMethodDropdown(
                        value: _selectedPaymentMethod,
                        items: _paymentMethods,
                        onChanged: (value) {
                          setState(() => _selectedPaymentMethod = value!);
                        },
                      ),

                      const SizedBox(height: 24),

                      // Date Field
                      _SectionTitle(title: 'Date'),
                      const SizedBox(height: 12),
                      _DateField(
                        controller: _dateController,
                        selectedDate: _selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date;
                            _dateController.text =
                                DateFormat('EEEE, MMMM d, yyyy').format(date);
                          });
                        },
                      ),

                      const SizedBox(height: 32),

                      // Action Buttons
                      BlocBuilder<ExpenseBloc, ExpenseState>(
                        builder: (context, state) {
                          final isLoading = state is ExpenseLoading;
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
          return null;
        },
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const _CategoryGrid({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ExpenseCategories.all;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.name;

          return InkWell(
            onTap: () => onCategorySelected(category.name),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? category.color.withOpacity(0.15)
                    : Colors.transparent,
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
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    size: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? category.color : null,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

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
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 3,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          hintText: 'Add a description (optional)',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
        ),
      ),
    );
  }
}

class _PaymentMethodDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _PaymentMethodDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
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
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((method) => DropdownMenuItem(
          value: method,
          child: Text(method),
        ))
            .toList(),
        onChanged: onChanged,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.payment),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final TextEditingController controller;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _DateField({
    required this.controller,
    required this.selectedDate,
    required this.onDateSelected,
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
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.calendar_today),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            onDateSelected(picked);
          }
        },
      ),
    );
  }
}