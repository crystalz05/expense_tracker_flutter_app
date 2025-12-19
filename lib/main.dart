import 'package:expenses_tracker_app/core/presentation/cubit/budget_cubit.dart';
import 'package:expenses_tracker_app/core/presentation/cubit/theme_cubit.dart';
import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expenses_tracker_app/features/auth/presentation/pages/login_page.dart';
import 'package:expenses_tracker_app/features/auth/presentation/pages/splash_page.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/bloc/expense_event.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/home_page.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/main_page.dart';
import 'package:expenses_tracker_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => sl<AuthBloc>()..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (_) => sl<ExpenseBloc>(),
          ),
          BlocProvider(
            create: (_) => sl<ThemeCubit>(),
          ),
          BlocProvider(
              create: (_) => sl<BudgetCubit>()
          )
        ],
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Tyro Spend Wise',
          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.dark),
          ),
          themeMode: context.read<ThemeCubit>().themeMode,
          home: LoginPage()
        );
      },
    );
  }
}