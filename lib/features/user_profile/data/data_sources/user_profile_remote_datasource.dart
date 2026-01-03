
import 'dart:io';

import 'package:expenses_tracker_app/features/user_profile/data/models/user_profile_model.dart';

abstract class UserProfileRemoteDatasource {
  Future<UserProfileModel> getUserProfile(String userId);
  Future<UserProfileModel> createUserProfile(UserProfileModel profile);
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile);
  Future<UserProfileModel> uploadProfilePhoto(String userId, File photoFile);
  Future<void> deleteProfilePhoto(String userId, String photoUrl);
}