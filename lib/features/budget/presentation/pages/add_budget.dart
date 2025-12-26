import 'package:expenses_tracker_app/features/budget/presentation/widgets/buttons_widget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/widgets/period_drop_down_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../expenses/presentation/widgets/dropdown_menu_widget.dart';

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
  String? _selectedCategory;
  DateTime? startDate;
  bool? _isRecurring;
  Period? _period;
  double? _alertThreshold;

  @override void dispose() {
    _budgetAmountController.dispose();
    _budgetDescriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override void initState() {
    super.initState();

    startDate = DateTime.now();
    _startDateController.text =
        DateFormat('EEEE, MMMM d, yyyy').format(startDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add Budget"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create a budget to track your spending in a specific category",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w300)),
              SizedBox(height: 16,),
              Text("Budget Description", style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 8,),
              TextField(
                controller: _budgetDescriptionController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "e.g., Monthly Groceries?",
                  hintStyle: TextStyle(fontWeight: FontWeight.w200),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),

              SizedBox(height: 24,),
              Text("Budget Amount (₦)", style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 8,),
              TextFormField(
                controller: _budgetAmountController,
                maxLines: 1,
                keyboardType: TextInputType.numberWithOptions(),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                ],
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter an amount' : null,
                decoration: InputDecoration(
                  hintText: "0.00",
                  hintStyle: TextStyle(fontWeight: FontWeight.w200),
                  prefixText: "₦ ",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 24,),
              Text(
                "Categories",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(height: 24,),
              Text(
                "Start Date",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              TextField(
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
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      startDate = pickedDate;
                      _startDateController.text =
                          DateFormat('EEEE, MMMM d, yyyy').format(pickedDate);
                    });
                  }
                },
              ),

              const SizedBox(width: 12),

              SizedBox(height: 24,),
              Text(
                "End Date",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _endDateController,
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
                    initialDate: endDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime(1900),
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
              Text(
                "Period",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
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
              Row(
                children: [
                  Expanded(child: ButtonsWidget(
                      textColor: Theme.of(context).colorScheme.onError,
                      color: Theme.of(context).colorScheme.error,
                      buttonName: "Cancel",
                      onPressed: () {})),
                  SizedBox(width: 24),
                  Expanded(child: ButtonsWidget(
                      buttonName: "Add Budget",
                      onPressed: () {})),

                ],
              )
            ],
          ),
        ),
      ),
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