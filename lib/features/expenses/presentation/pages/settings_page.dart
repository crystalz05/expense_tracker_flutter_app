import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expenses_tracker_app/features/expenses/presentation/pages/sign_out_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/settings_widget/budget_card.dart';
import '../widgets/settings_widget/about_card.dart';
import '../widgets/settings_widget/cleanup_card.dart';
import '../widgets/settings_widget/preferences_card.dart';
import '../widgets/settings_widget/section_header.dart';
import '../widgets/settings_widget/sync_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go("/login");
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Settings",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Customize your experience",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 32),

              // Budget Section
              SectionHeader(
                icon: Icons.account_balance_wallet,
                title: 'BUDGET',
              ),
              const SizedBox(height: 12),
              BudgetCard(),
              const SizedBox(height: 32),

              // Data Management Section
              SectionHeader(
                icon: Icons.sync,
                title: 'DATA MANAGEMENT',
              ),
              const SizedBox(height: 12),
              SyncCard(),
              const SizedBox(height: 12),
              CleanupCard(),
              const SizedBox(height: 32),

              // Preferences Section
              SectionHeader(
                icon: Icons.settings_outlined,
                title: 'PREFERENCES',
              ),
              const SizedBox(height: 12),
              PreferencesCard(),
              const SizedBox(height: 32),

              // About Section
              SectionHeader(
                icon: Icons.info_outline,
                title: 'ABOUT',
              ),
              const SizedBox(height: 12),
              AboutCard(),
              const SizedBox(height: 32),

              // Sign Out Button
              SignOutButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

