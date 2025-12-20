

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

  }

  // @override
  // Widget build(BuildContext context) {
  //   return const Scaffold(
  //     body: Center(child: CircularProgressIndicator()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        // splash delay
        await Future.delayed(const Duration(seconds: 2));

        if (state is AuthAuthenticated) {
          // TODO context.go('/home');
        } else if (state is AuthUnauthenticated) {
          // TODO context.go('/login');
        }
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
