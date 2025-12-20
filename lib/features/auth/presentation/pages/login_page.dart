
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
  bool _obscurePassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn(){
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
            if(state is AuthError){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red)
              );
            }
            if (state is AuthAuthenticated) {
              //TODO NAVIGATE TO MAIN PAGE
            }
          }, builder: (BuildContext context, AuthState state) {

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
                                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16)
                            ),
                            child: Icon(
                              Icons.account_balance_wallet,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ),

                          ),
                          SizedBox(height: 24),
                          Text("Welcome Back", style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800)),
                          SizedBox(height: 6),
                          Text("Sign in to continue tracking your expenses", style: Theme.of(context).textTheme.titleMedium),
                          SizedBox(height: 24),
                          Card(
                            color: Theme.of(context).colorScheme.surface,
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("Email", style: Theme.of(context).textTheme.titleMedium),
                                    SizedBox(height: 4),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: "you@example.com",
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
                                    ),

                                    TextField(
                                      controller: _emailController,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: "What did you spend on?",
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      textCapitalization: TextCapitalization.sentences,
                                    ),
                                    Divider(height: 1),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: !_obscurePassword,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              )
                          )
                        ],
                      )
                  ),
                ),
              )
          );
        },
        )
    );
  }
}