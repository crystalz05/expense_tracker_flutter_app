
import 'package:expenses_tracker_app/features/auth/presentation/pages/login_page.dart';
import 'package:expenses_tracker_app/features/auth/presentation/pages/signup_page.dart';
import 'package:expenses_tracker_app/features/auth/presentation/pages/splash_page.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/main_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
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
      )
    ]
);