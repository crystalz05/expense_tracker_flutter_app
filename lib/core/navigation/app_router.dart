
import 'package:expenses_tracker_app/core/navigation/route_observer.dart';
import 'package:expenses_tracker_app/features/auth/presentation/pages/login_page.dart';
import 'package:expenses_tracker_app/features/auth/presentation/pages/signup_page.dart';
import 'package:expenses_tracker_app/features/auth/presentation/pages/splash_page.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/pages/add_budget.dart';
import 'package:expenses_tracker_app/features/budget/presentation/pages/budget_detail_page.dart';
import 'package:expenses_tracker_app/features/budget/presentation/pages/budget_page.dart';
import 'package:expenses_tracker_app/features/budget/presentation/pages/edit_budget_page.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/add_expense_page.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/edit_expense_page.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/expense_detail_page.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/main_page.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/entities/user_profile.dart';
import 'package:expenses_tracker_app/features/user_profile/presentation/pages/edit_profile_page.dart';
import 'package:expenses_tracker_app/features/user_profile/presentation/pages/profile_page.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/presentation/pages/analytics_page.dart';

final GoRouter router = GoRouter(
    observers: [
      routeObserver
    ],
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/main-page',
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: '/budget-page',
        builder: (context, state) => const BudgetPage(),
      ),
      GoRoute(
          path: '/budget-detail-page/:id',
          builder: (context, state) {
            final budgetId = state.pathParameters['id']!;
            return BudgetDetailPage(budgetId: budgetId);
          }
      ),
      GoRoute(
        path: '/add-budget-page',
        builder: (context, state) => const AddBudgetPage(),
      ),
      GoRoute(
        path: '/edit-budget-page',
        builder: (context, state) {
          final budget = state.extra as Budget;
          return EditBudgetPage(budget: budget);
        }
      ),
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const AnalyticsPage()
      ),
      GoRoute(
          path: '/add-expense',
          builder: (context, state) => const AddExpensePage()
      ),
      GoRoute(
          path: '/edit-expense',
          builder: (context, state) {
            final expense = state.extra as Expense;
            return EditExpensePage(expense: expense);
          }
      ),
      GoRoute(
          path: '/expense-detail-page',
          builder: (context, state) {
            final expense = state.extra as Expense;
            return ExpenseDetailPage(expense: expense);
          }
      ),
      GoRoute(
        path: '/profile-page',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) {
          final profile = state.extra as UserProfile;
          return EditProfilePage(profile: profile);
        }
      ),
    ],
);