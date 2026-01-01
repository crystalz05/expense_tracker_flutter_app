import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../pages/expenses_history_page.dart';
import 'date_button.dart';
import 'expense_filter_model.dart';

class FilterBottomSheet extends StatefulWidget {
  final ExpenseFilters currentFilters;
  final ValueChanged<ExpenseFilters> onApplyFilters;

  const FilterBottomSheet({
    required this.currentFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TextEditingController _minAmountController;
  late TextEditingController _maxAmountController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _minAmountController = TextEditingController(
      text: widget.currentFilters.minAmount?.toString() ?? '',
    );
    _maxAmountController = TextEditingController(
      text: widget.currentFilters.maxAmount?.toString() ?? '',
    );
    _startDate = widget.currentFilters.startDate;
    _endDate = widget.currentFilters.endDate;
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Amount Range
            Text(
              'Amount Range',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Min',
                      prefixText: '₦',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Max',
                      prefixText: '₦',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Date Range
            Text(
              'Date Range',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DateButton(
                    label: 'Start Date',
                    date: _startDate,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _startDate = picked);
                      }
                    },
                    onClear: _startDate != null
                        ? () => setState(() => _startDate = null)
                        : null,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DateButton(
                    label: 'End Date',
                    date: _endDate,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: _startDate ?? DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _endDate = picked);
                      }
                    },
                    onClear:
                    _endDate != null ? () => setState(() => _endDate = null) : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _minAmountController.clear();
                        _maxAmountController.clear();
                        _startDate = null;
                        _endDate = null;
                      });
                    },
                    child: Text('Reset'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final minAmount = double.tryParse(_minAmountController.text);
                      final maxAmount = double.tryParse(_maxAmountController.text);

                      widget.onApplyFilters(
                        widget.currentFilters.copyWith(
                          minAmount: minAmount,
                          maxAmount: maxAmount,
                          startDate: _startDate,
                          endDate: _endDate,
                          clearMinAmount: _minAmountController.text.isEmpty,
                          clearMaxAmount: _maxAmountController.text.isEmpty,
                          clearStartDate: _startDate == null,
                          clearEndDate: _endDate == null,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}