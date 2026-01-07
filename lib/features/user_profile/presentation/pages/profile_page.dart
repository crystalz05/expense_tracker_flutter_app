// File: lib/features/user_profile/presentation/pages/profile_page.dart

import 'dart:io';
import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/entities/user_profile.dart';
import 'package:expenses_tracker_app/features/user_profile/presentation/bloc/user_profile_bloc.dart';
import 'package:expenses_tracker_app/features/user_profile/presentation/bloc/user_profile_event.dart';
import 'package:expenses_tracker_app/features/user_profile/presentation/bloc/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(LoadUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
            if (state.message.contains("No cached") || state.message.contains("not found")) {
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthAuthenticated) {
                context.read<UserProfileBloc>().add(CreateUserProfileEvent());
              }
            }
          } else if (state is UserProfilePhotoUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Profile photo updated successfully'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Reload profile after upload
            context.read<UserProfileBloc>().add(LoadUserProfileEvent());
          } else if (state is UserProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Profile updated successfully'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Reload profile after update
            context.read<UserProfileBloc>().add(LoadUserProfileEvent());
          }
        },
        builder: (context, state) {
          if (state is UserProfileLoading || state is UserProfilePhotoUploading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserProfileLoaded || state is UserProfileUpdated) {
            final profile = state is UserProfileLoaded
                ? state.profile
                : (state as UserProfileUpdated).profile;

            print(profile.profilePhotoUrl);

            return _buildProfileContent(context, profile);
          }
          // Initial state or error - show basic UI
          return _buildEmptyState(context);
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserProfile profile) {
    return CustomScrollView(
      slivers: [
        // Modern App Bar with Profile Photo
        _ModernProfileAppBar(profile: profile),

        // Profile Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Card
                _UserInfoCard(profile: profile),

                const SizedBox(height: 24),

                // Quick Actions
                _QuickActionsSection(profile: profile),

                const SizedBox(height: 24),

                // Account Settings
                _AccountSettingsSection(),

                const SizedBox(height: 24),

                // Danger Zone
                _DangerZoneSection(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Profile Not Found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              context.read<UserProfileBloc>().add(LoadUserProfileEvent());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ==================== MODERN PROFILE APP BAR ====================
class _ModernProfileAppBar extends StatelessWidget {
  final UserProfile profile;

  const _ModernProfileAppBar({required this.profile});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () {
            context.push('/edit-profile', extra: profile);
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.7),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // Profile Photo with Edit Button
              _ProfilePhotoSection(profile: profile),
              const SizedBox(height: 16),
              // User Name from Auth
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return Column(
                      children: [
                        Text(
                          state.user.displayName ?? 'User',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.user.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== PROFILE PHOTO SECTION ====================
class _ProfilePhotoSection extends StatelessWidget {
  final UserProfile profile;

  const _ProfilePhotoSection({required this.profile});

  Future<void> _pickAndUploadPhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(bottomSheetContext);

                final XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: 1024,
                  maxHeight: 1024,
                  imageQuality: 85,
                );

                if (image != null && context.mounted) {
                  context.read<UserProfileBloc>().add(
                    UploadProfilePhotoEvent(File(image.path)),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(bottomSheetContext);

                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 1024,
                  maxHeight: 1024,
                  imageQuality: 85,
                );

                if (image != null && context.mounted) {
                  context.read<UserProfileBloc>().add(
                    UploadProfilePhotoEvent(File(image.path)),
                  );
                }
              },
            ),
            if (profile.profilePhotoUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(bottomSheetContext);

                  if (context.mounted) {
                    context.read<UserProfileBloc>().add(
                      DeleteProfilePhotoEvent(profile.profilePhotoUrl!),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            backgroundImage: profile.profilePhotoUrl != null
                ? NetworkImage(profile.profilePhotoUrl!)
                : null,
            child: profile.profilePhotoUrl == null
                ? Icon(
              Icons.person,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            )
                : null,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => _pickAndUploadPhoto(context),
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== USER INFO CARD ====================
class _UserInfoCard extends StatelessWidget {
  final UserProfile profile;

  const _UserInfoCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            value: profile.phoneNumber ?? 'Not set',
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Member Since',
            value: DateFormat('MMMM d, yyyy').format(profile.createAt),
          ),
          if (profile.updatedAt != null) ...[
            const Divider(height: 24),
            _InfoRow(
              icon: Icons.update_outlined,
              label: 'Last Updated',
              value: DateFormat('MMM d, yyyy h:mm a').format(profile.updatedAt!),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== QUICK ACTIONS SECTION ====================
class _QuickActionsSection extends StatelessWidget {
  final UserProfile profile;

  const _QuickActionsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.edit_outlined,
                label: 'Edit Profile',
                color: Colors.blue,
                onTap: () => context.push('/edit-profile', extra: profile),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.security_outlined,
                label: 'Security',
                color: Colors.orange,
                onTap: () {
                  // Navigate to security settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Security settings coming soon')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== ACCOUNT SETTINGS SECTION ====================
class _AccountSettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications settings coming soon')),
              );
            },
          ),
          const Divider(height: 1, indent: 72),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy',
            subtitle: 'Manage your privacy settings',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy settings coming soon')),
              );
            },
          ),
          const Divider(height: 1, indent: 72),
          _SettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help and support',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
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
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
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
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

// ==================== DANGER ZONE SECTION ====================
class _DangerZoneSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                'Danger Zone',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);

                          // Use the outer context which is still valid
                          if (context.mounted) {
                            context.read<AuthBloc>().add(AuthSignOutRequested());
                            context.go('/login');
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}