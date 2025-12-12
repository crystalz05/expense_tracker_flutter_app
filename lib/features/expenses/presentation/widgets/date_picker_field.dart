
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget{
  const DatePickerField({super.key});


  @override
  State<DatePickerField> createState() => _DatePickerField();

}

class _DatePickerField extends State<DatePickerField>{
  final TextEditingController _controller = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: "Select date",
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
        ),
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100)
        );
        if(picked != null){
          setState(() {
            selectedDate = picked;
            _controller.text = DateFormat("dd MMM, yyyy").format(picked);
          });
        }
      },
    );

  }
}