// lib/features/expenses/presentation/widgets/home_content.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/expense_bloc.dart';
import '../../bloc/expense_state.dart';
import 'home_loaded_content.dart';
import 'home_loading_state.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return const HomeLoadingState();
        } else if (state is ExpensesByPeriodLoaded) {
          return HomeLoadedContent(state: state);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
