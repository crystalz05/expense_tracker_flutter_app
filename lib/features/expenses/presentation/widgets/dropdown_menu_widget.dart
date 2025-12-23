
import 'package:flutter/material.dart';

class DropdownMenuWidget extends StatefulWidget{
  final ValueChanged<String> paymentMethodSelected;

  const DropdownMenuWidget({super.key, required this.paymentMethodSelected});

  @override
  State<StatefulWidget> createState() => _DropdownMenuWidget();
}

class _DropdownMenuWidget extends State<DropdownMenuWidget>{
  String selectedCategory = 'Card';

  @override
  Widget build(BuildContext context) {
    return
      DropdownMenu<String>(
        menuStyle: MenuStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surface)
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        initialSelection: selectedCategory,
        dropdownMenuEntries: const [
          DropdownMenuEntry(value: "Cash", label: "Cash"),
          DropdownMenuEntry(value: "Card", label: "Card"),
        ],
        onSelected: (value) {
          setState(() => selectedCategory = value!);
          widget.paymentMethodSelected(value!);
        },
      );

  }
}