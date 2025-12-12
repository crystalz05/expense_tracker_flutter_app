
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpensesHistoryPage extends StatelessWidget {
  const ExpensesHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(padding: EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("History", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text("View all your transactions", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey)),
                SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.filter_alt_outlined, size: 20),
                    SizedBox(width: 8,),
                    Text("Filter", style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 8,
                    children: [
                      Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),
                              side: BorderSide(color: Theme.of(context).colorScheme.outline) ),
                          child:
                          Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Text("Hello"),
                          )
                      ),
                      Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),
                              side: BorderSide(color: Theme.of(context).colorScheme.outline) ),
                          child:
                          Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Text("Food & Dining"),
                          )
                      ),
                      Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),
                              side: BorderSide(color: Theme.of(context).colorScheme.outline) ),
                          child:
                          Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Text("Transport"),
                          )
                      ),
                      Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),
                              side: BorderSide(color: Theme.of(context).colorScheme.outline) ),
                          child:
                          Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Text("Hello"),
                          )
                      ),
                      Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),
                              side: BorderSide(color: Theme.of(context).colorScheme.outline) ),
                          child:
                          Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Text("Food & Dining"),
                          )
                      ),
                      Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),
                              side: BorderSide(color: Theme.of(context).colorScheme.outline) ),
                          child:
                          Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Text("Transport"),
                          )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8,)
              ],
            )
        )
    );
  }
}