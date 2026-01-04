import 'dart:io';

import 'package:expenses_tracker_app/features/user_profile/data/data_sources/user_profile_remote_datasource.dart';
import 'package:expenses_tracker_app/features/user_profile/data/models/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';

class UserProfileRemoteDatasourceImpl implements UserProfileRemoteDatasource {

  final SupabaseClient supabaseClient;

  UserProfileRemoteDatasourceImpl({required this.supabaseClient});

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      // Use maybeSingle() instead of single() - returns null if not found
      final response = await supabaseClient
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle(); // ✅ Returns null instead of throwing error

      if (response == null) {
        throw ServerException('Profile not found for user: $userId' '. Will now proceed to create one' );
      }

      return UserProfileModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<UserProfileModel> createUserProfile(UserProfileModel profile) async {
    try {
      final response = await supabaseClient
          .from('user_profiles')
          .insert(profile.toJson())
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to create user profile: $e');
    }
  }


  @override
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    try {
      final response = await supabaseClient
          .from('user_profiles')
          .update({
        'profile_photo_url': profile.profilePhotoUrl,
        'phone_number': profile.phoneNumber,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('user_id', profile.userId)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to update user profile: $e');
    }
  }

  @override
  Future<void> deleteProfilePhoto(String userId, String photoUrl) async {
    try {
      final uri = Uri.parse(photoUrl);
      final path = uri.pathSegments.last;

      // Delete from storage
      await supabaseClient.storage
          .from('profile_photos')
          .remove(['$userId/$path']);

      // Remove URL from database
      await supabaseClient
          .from('user_profiles')
          .update({
        'profile_photo_url': null,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('user_id', userId);

    } catch (e) {
      throw ServerException('Failed to delete profile photo: $e');
    }
  }

  @override
  Future<UserProfileModel> uploadProfilePhoto(String userId, File photoFile) async {
    try {
      final bytes = await photoFile.readAsBytes();
      final fileExt = photoFile.path.split('.').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '$userId/profile_$timestamp.$fileExt';

      await supabaseClient.storage
          .from('profile_photos')
          .uploadBinary(
        filePath,
        bytes,
        fileOptions: const FileOptions(upsert: true),
      );

      final url = supabaseClient.storage
          .from('profile_photos')
          .getPublicUrl(filePath);

      final response = await supabaseClient
          .from('user_profiles')
          .update({
        'profile_photo_url': url,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('user_id', userId)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to upload profile photo: $e');
    }
  }
}