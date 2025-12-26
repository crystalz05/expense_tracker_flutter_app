import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeriodDropDownMenu<T extends Enum> extends StatefulWidget {
  final double? width;
  final List<T> items;
  final T initialValue;
  final ValueChanged<T> onSelected;
  final String Function(T) labelBuilder;

  const PeriodDropDownMenu({
    super.key,
    this.width,
    required this.items,
    required this.initialValue,
    required this.onSelected,
    required this.labelBuilder,
  });

  @override
  State<PeriodDropDownMenu<T>> createState() => _PeriodDropDownMenu<T>();
}

class _PeriodDropDownMenu<T extends Enum>
    extends State<PeriodDropDownMenu<T>> {
  late T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      leadingIcon: Icon(Icons.loop),
      width: widget.width,
      initialSelection: selectedValue,
      dropdownMenuEntries: widget.items
          .map(
            (item) => DropdownMenuEntry<T>(
          value: item,
          label: widget.labelBuilder(item),
        ),
      )
          .toList(),
      onSelected: (value) {
        if (value == null) return;
        setState(() => selectedValue = value);
        widget.onSelected(value);
      },
    );
  }
}
