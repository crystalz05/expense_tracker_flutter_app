import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is AuthAuthenticated) {
            context.go("/main-page");
          }
        },
        builder: (BuildContext context, AuthState state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Welcome Back",
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Sign in to continue tracking your expenses",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 24),
                      Card(
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.all(
                            Radius.circular(12),
                          ),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(height: 4),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "you@example.com",
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true)
                                    return 'Please enter your email';
                                  if (!value!.contains('@'))
                                    return 'Invalid email';
                                  return null;
                                },
                                enabled: !isLoading,
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Password",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "********",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: _obscurePassword
                                        ? Icon(CupertinoIcons.eye_slash)
                                        : Icon(CupertinoIcons.eye),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) return 'Required';
                                  if (value!.length < 6)
                                    return 'Minimum 6 characters';
                                  return null;
                                },
                                enabled: !isLoading,
                              ),
                              SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    foregroundColor: WidgetStatePropertyAll(
                                      Theme.of(context).colorScheme.onPrimary,
                                    ),
                                    elevation: WidgetStatePropertyAll(0),
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsetsGeometry.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    backgroundColor: WidgetStatePropertyAll(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    isLoading ? null : _signIn;
                                    _signIn();
                                  },
                                  child: isLoading
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Sign In"),
                                            SizedBox(width: 12),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 12,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account?"),
                                    TextButton(
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              context.go('/signup');
                                            },
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
