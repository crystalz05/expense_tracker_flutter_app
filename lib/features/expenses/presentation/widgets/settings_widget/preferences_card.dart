import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/presentation/cubit/offline_mode_cubit.dart';
import '../../../../../core/presentation/cubit/theme_cubit.dart';

class PreferencesCard extends StatelessWidget {
  const PreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          _PreferenceItem(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Toggle dark theme',
            trailing: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                bool isDark = state == ThemeState.dark;
                return Switch(
                  value: isDark,
                  onChanged: (newValue) {
                    context.read<ThemeCubit>().setTheme(
                      newValue ? ThemeState.dark : ThemeState.light,
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1, indent: 72),
          // NEW: Offline Mode Toggle
          _PreferenceItem(
            icon: Icons.cloud_off,
            title: 'Offline Mode',
            subtitle: 'Disable cloud sync',
            trailing: BlocBuilder<OfflineModeCubit, bool>(
              builder: (context, isOffline) {
                return Switch(
                  value: isOffline,
                  onChanged: (newValue) {
                    context.read<OfflineModeCubit>().setOfflineMode(newValue);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          newValue
                              ? 'Offline mode enabled - App will not sync with cloud'
                              : 'Offline mode disabled - App will sync with cloud',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1, indent: 72),
          _PreferenceItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'How we handle your data',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to privacy policy
            },
          ),
          const Divider(height: 1, indent: 72),
          _PreferenceItem(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'App terms and conditions',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to terms
            },
          ),
        ],
      ),
    );
  }
}

class _PreferenceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _PreferenceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
