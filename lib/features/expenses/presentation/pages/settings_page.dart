
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
          child: Padding(padding: EdgeInsetsGeometry.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Settings", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text("Customize your experience", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey)),
                    SizedBox(height: 24),
                    Text("BUDGET", style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: 8,),
                    Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.5
                          ),
                        ),
                        child:
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            child:
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                                              borderRadius: BorderRadius.circular(16)
                                          ),
                                          child: Icon(Icons.account_balance_wallet_rounded, color: Theme.of(context).colorScheme.primary, size: 18),
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Monthly Budget", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400)),
                                            Text("Set your spending limit", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text("₦200,000.00", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: Colors.green)),
                                  ],
                                ),

                              ],
                            )
                        )
                    ),
                    SizedBox(height: 24),
                    Text("Preferences", style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: 8,),
                    Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.5
                          ),
                        ),
                        child:
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            child:
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                                              borderRadius: BorderRadius.circular(16)
                                          ),
                                          child: Icon(Icons.account_balance_wallet_rounded, color: Theme.of(context).colorScheme.primary, size: 18),
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Dark Mode", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400)),
                                            Text("Toggle dark theme", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Switch(value: true, onChanged: (newValue) {} ),
                                  ],
                                ),

                              ],
                            )
                        )
                    ),
                    SizedBox(height: 24),
                    Text("Preferences", style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: 8,),
                    Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.5
                          ),
                        ),
                        child:
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            child:
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                                              borderRadius: BorderRadius.circular(16)
                                          ),
                                          child: Icon(Icons.account_balance_wallet_rounded, color: Theme.of(context).colorScheme.primary, size: 18),
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Privacy Policy", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400)),
                                            Text("How we handle your data", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios))
                                  ],
                                ),
                                Divider(color: Colors.grey, height: 38,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                                              borderRadius: BorderRadius.circular(16)
                                          ),
                                          child: Icon(Icons.account_balance_wallet_rounded, color: Theme.of(context).colorScheme.primary, size: 18),
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Privacy Policy", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400)),
                                            Text("How we handle your data", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios))
                                  ],
                                ),

                              ],
                            )
                        )
                    ),
                  ]
              )
          )
      );
  }
}