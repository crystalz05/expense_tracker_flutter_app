import '../models/user_profile_model.dart';

abstract class UserProfileCacheDataSource {
  Future<UserProfileModel?> getCachedProfile(String userId);
  Future<void> cacheProfile(UserProfileModel profile);
  Future<void> clearCache();
}
