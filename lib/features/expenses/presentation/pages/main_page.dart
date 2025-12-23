
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/add_expense_page.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/expenses_history_page.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});


  @override
  State<MainPage> createState() => _MainPage();

}

class _MainPage extends State<MainPage>{
  int currentIndex = 0;
  late final List<Widget> pages; // <-- declare late final


  void _goHome() {
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpensesEvent());

    // Initialize pages here after 'this' is available
    pages = [
      const HomePage(),
      AddExpensePage(
        onExpenseAdded: _goHome, // safe now
      ),
      const ExpensesHistoryPage(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[currentIndex]),
      bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Theme.of(context).colorScheme.surface,
              labelTextStyle: WidgetStateProperty.resolveWith((states){
                if(states.contains(WidgetState.selected)){
                  return TextStyle(
                      color: Theme.of(context).colorScheme.primary
                  );
                }
                return const TextStyle(
                    color: Colors.grey
                );
              }),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
              child: NavigationBar(
                indicatorColor: Colors.transparent,
                selectedIndex: currentIndex,
                  onDestinationSelected: (index){
                  setState(() {
                    currentIndex = index;
                  });
                },
                destinations: [
                  NavigationDestination(
                      icon: Icon(Icons.home_outlined, color: Colors.grey,),
                      selectedIcon: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
                      label: "Home"),
                  NavigationDestination(
                      icon: const Icon(CupertinoIcons.add_circled, color: Colors.grey,),
                      selectedIcon: Icon(CupertinoIcons.add_circled_solid, color: Theme.of(context).colorScheme.primary,),
                      label: "Add"),
                  NavigationDestination(
                      icon: Icon(Icons.history_outlined, color: Colors.grey,),
                      selectedIcon: Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
                      label: "History"),
                  NavigationDestination(
                      icon: Icon(Icons.settings_outlined, color: Colors.grey,),
                      selectedIcon: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
                      label: "Settings"),
                ],
              )
          )
      ),
    );
  }
}