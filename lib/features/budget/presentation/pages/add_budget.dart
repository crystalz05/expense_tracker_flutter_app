import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddBudget extends StatefulWidget {
  final VoidCallback onBudgetAdded;

  const AddBudget({super.key, required this.onBudgetAdded});

  @override
  State<StatefulWidget> createState() => _AddBudgetState();

}

class _AddBudgetState extends State<AddBudget> {
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [


              // Add your form fields and buttons here
            ],
          ),
        ),
      ),
    );
  }
}