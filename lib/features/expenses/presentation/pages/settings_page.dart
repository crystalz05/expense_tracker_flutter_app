
import 'package:expenses_tracker_app/features/expenses/presentation/misc/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/cubit/budget_cubit.dart';
import '../../../../core/presentation/cubit/theme_cubit.dart';
import '../widgets/budget_dialog.dart';

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
                        color: Theme.of(context).colorScheme.surface,
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
                                    BlocBuilder<BudgetCubit, BudgetState>(
                                      builder: (context, state) {
                                        return Row(
                                          children: [
                                            Text("₦${formatter.format(state.monthlyBudget)}"),
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () async {
                                                double newBudget = await showDialog(
                                                  context: context,
                                                  builder: (_) => BudgetDialog(initialBudget: state.monthlyBudget),
                                                );
                                                context.read<BudgetCubit>().setBudget(newBudget);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    )
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
                        color: Theme.of(context).colorScheme.surface,
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
                                    BlocBuilder<ThemeCubit, ThemeState>(
                                      builder: (context, state) {
                                        bool isDark = state == ThemeState.dark;

                                        return Switch(
                                          value: isDark,
                                          onChanged: (newValue) {
                                            // Toggle between light and dark
                                            if (newValue) {
                                              context.read<ThemeCubit>().setTheme(ThemeState.dark);
                                            } else {
                                              context.read<ThemeCubit>().setTheme(ThemeState.light);
                                            }
                                          },
                                        );
                                      },
                                    ),
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
                        color: Theme.of(context).colorScheme.surface,
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