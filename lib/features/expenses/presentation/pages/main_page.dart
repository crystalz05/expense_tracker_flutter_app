
import 'package:expenses_tracker_app/features/expenses/presentation/pages/add_expense_page.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/expenses_history_page.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();

}

class _MainPage extends State<MainPage>{
  int currentIndex = 0;

  final pages = [
    HomePage(),
    AddExpensePage(),
    ExpensesHistoryPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[currentIndex]),
      bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              labelTextStyle: WidgetStateProperty.resolveWith((states){
                if(states.contains(WidgetState.selected)){
                  return TextStyle(
                      color: Theme.of(context).colorScheme.primary
                  );
                }
                return const TextStyle(
                    color: Colors.grey
                );
              })
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
                      icon: const Icon(Icons.add_box_outlined, color: Colors.grey,),
                      selectedIcon: Icon(Icons.add_box, color: Theme.of(context).colorScheme.primary,),
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