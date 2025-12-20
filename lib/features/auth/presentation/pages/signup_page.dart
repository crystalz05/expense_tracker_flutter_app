
import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpPageState();

}

class _SignUpPageState extends State<SignupPage> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _obscurePassword = false;
  bool _obscureConfirmPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _signUp(){
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignUpRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _displayNameController.text.trim().isEmpty ? null : _displayNameController.text.trim(),
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
              context.go("/main-page");
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
                                color: Theme.of(context).colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(16)
                            ),
                            child: Icon(
                              Icons.account_balance_wallet,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ),

                          ),
                          SizedBox(height: 24),
                          Text("Create Account", style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800)),
                          SizedBox(height: 6),
                          Text("Start tracking your expenses today", style: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(height: 24),
                          Card(
                            color: Theme.of(context).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
                                side: BorderSide(color: Theme.of(context)
                                    .colorScheme.outline.withValues(alpha: 0.2))),
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text("Display Name", style: Theme.of(context).textTheme.titleMedium),
                                  SizedBox(height: 4),
                                  TextFormField(
                                    controller: _displayNameController,
                                    keyboardType: TextInputType.name,
                                    textCapitalization: TextCapitalization.words,
                                    decoration: InputDecoration(
                                        hintText: "John Doe",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your display name';
                                      }
                                      return null;
                                    },
                                    enabled: !isLoading,
                                  ),
                                  SizedBox(height: 6),
                                  Text("Email", style: Theme.of(context).textTheme.titleMedium),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        hintText: "you@example.com",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                                    ),
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) return 'Required';
                                      if (!value!.contains('@')) return 'Invalid email';
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 6),
                                  Text("Password", style: Theme.of(context).textTheme.titleMedium),
                                  TextFormField(
                                    controller: _passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                        hintText: "********",
                                        helperText: "Must be at least 6 characters",
                                        suffixIcon: IconButton(onPressed: (){
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        }, icon: _obscurePassword ? Icon(CupertinoIcons.eye_slash) : Icon(CupertinoIcons.eye)),
                                        hintStyle: TextStyle(color: Colors.grey),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                                    ),
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) return 'Required';
                                      if (value!.length < 6) return 'Minimum 6 characters';
                                      return null;
                                    },
                                    enabled: !isLoading,
                                  ),
                                  SizedBox(height: 6),
                                  Text("Confirm Password", style: Theme.of(context).textTheme.titleMedium),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: _obscureConfirmPassword,
                                    decoration: InputDecoration(
                                        hintText: "********",
                                        suffixIcon: IconButton(onPressed: (){
                                          setState(() {
                                            _obscureConfirmPassword = !_obscureConfirmPassword;
                                          });
                                        }, icon: _obscureConfirmPassword ? Icon(CupertinoIcons.eye_slash) : Icon(CupertinoIcons.eye)),
                                        hintStyle: TextStyle(color: Colors.grey),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                                    ),
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) return 'Required';
                                      if (value != _passwordController.text) return 'Passwords do not match';
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24,),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onPrimary) ,
                                            elevation: WidgetStatePropertyAll(0),
                                            padding: WidgetStatePropertyAll(EdgeInsetsGeometry.symmetric(vertical: 14)),
                                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                                            shape: WidgetStatePropertyAll(
                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                            ) ),
                                        onPressed: (){
                                          if (!isLoading) _signUp();
                                        },
                                        child: isLoading
                                            ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ):Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Create Account"),
                                            SizedBox(width: 12,),
                                            Icon(Icons.arrow_forward_ios, size: 12,)
                                          ],
                                        )),
                                  ),
                                  SizedBox(height: 12,),
                                  SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Already have an account?"),
                                          TextButton(onPressed: (){
                                            context.go('/login');
                                          }, child: Text("Sign in", style: TextStyle(color: Colors.green),))
                                        ],
                                      )
                                  )
                                ],
                              ),
                            ),
                          ),
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