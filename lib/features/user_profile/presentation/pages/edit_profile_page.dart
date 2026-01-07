// File: lib/features/user_profile/presentation/pages/edit_profile_page.dart

import 'package:expenses_tracker_app/features/user_profile/domain/entities/user_profile.dart';
import 'package:expenses_tracker_app/features/user_profile/presentation/bloc/user_profile_bloc.dart';
import 'package:expenses_tracker_app/features/user_profile/presentation/bloc/user_profile_event.dart';
import 'package:expenses_tracker_app/features/user_profile/presentation/bloc/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: widget.profile.phoneNumber ?? '',
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = UserProfile(
        userId: widget.profile.userId,
        profilePhotoUrl: widget.profile.profilePhotoUrl,
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        createAt: widget.profile.createAt,
        updatedAt: DateTime.now(),
      );

      context.read<UserProfileBloc>().add(UpdateUserProfileEvent(updatedProfile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileUpdated) {
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
          context.pop();
        } else if (state is UserProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        body: CustomScrollView(
          slivers: [
            // Modern App Bar
            SliverAppBar(
              expandedHeight: 150,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => context.pop(),
              ),
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
                      const SizedBox(height: 40),
                      Icon(
                        Icons.edit_outlined,
                        size: 48,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Form Content
            SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Update your personal information',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Phone Number Field
                      _SectionTitle(title: 'Phone Number'),
                      const SizedBox(height: 12),
                      _PhoneNumberField(controller: _phoneController),

                      const SizedBox(height: 32),

                      // Action Buttons
                      BlocBuilder<UserProfileBloc, UserProfileState>(
                        builder: (context, state) {
                          final isLoading = state is UserProfileLoading;
                          return Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: isLoading ? null : () => context.pop(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FilledButton(
                                  onPressed: isLoading ? null : _submitForm,
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                      : const Text('Save Changes'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;

  const _PhoneNumberField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ]')),
          LengthLimitingTextInputFormatter(20),
        ],
        decoration: InputDecoration(
          hintText: 'Enter your phone number',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            // Basic phone validation - adjust based on your requirements
            final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
            if (digitsOnly.length < 10) {
              return 'Please enter a valid phone number';
            }
          }
          return null;
        },
      ),
    );
  }
}