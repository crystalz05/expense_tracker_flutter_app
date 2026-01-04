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
    try{
      final response = await supabaseClient
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .single();

      return UserProfileModel.fromJson(response);
    }catch(e){
      throw ServerException('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<UserProfileModel> createUserProfile(UserProfileModel profile) async {
    try{
      final response = await supabaseClient
          .from('user_profiles')
          .insert(profile.toJson())
          .select().single();

      return UserProfileModel.fromJson(response);
    }catch(e){
      throw ServerException('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    try{
      final response = await supabaseClient
          .from('user_profiles')
          .update({
        'profile_photo_url': profile.profilePhotoUrl,
        'phone_number': profile.phoneNumber
      })
          .eq('user_id', profile.userId)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    }catch(e){
      throw ServerException('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<void> deleteProfilePhoto(String userId, String photoUrl) async {
    try{
      final uri = Uri.parse(photoUrl);
      final path = uri.pathSegments.last;

      await supabaseClient.storage
          .from('profile_photos')
          .remove(['$userId/$path']);
    }catch(e){
      throw ServerException('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<UserProfileModel> uploadProfilePhoto(String userId, File photoFile) async {

    try{
      final bytes = await photoFile.readAsBytes();
      final fileExt = photoFile.path.split('.').last;
      final filePath = '$userId/profile.$fileExt';

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
          .update({'profile_photo_url': url})
          .eq('user_id', userId)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    }catch(e){
      throw ServerException('Failed to fetch user profile: $e');
    }
  }

}