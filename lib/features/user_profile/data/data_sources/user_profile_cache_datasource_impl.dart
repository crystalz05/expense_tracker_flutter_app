
import 'package:expenses_tracker_app/features/user_profile/data/data_sources/user_profile_cache_datasource.dart';
import 'package:expenses_tracker_app/features/user_profile/data/models/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileCacheDatasourceImpl implements UserProfileCacheDataSource {

  final SharedPreferences sharedPreferences;
  static const String _cacheKey = 'cached_user_profile';

  UserProfileCacheDatasourceImpl({required this.sharedPreferences});


  @override
  Future<void> cacheProfile(UserProfileModel profile) async {
    await sharedPreferences.setString(_cacheKey, profile.toJsonString());
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_cacheKey);
  }

  @override
  Future<UserProfileModel?> getCachedProfile(String userId) async {
    try {
      final jsonString = sharedPreferences.getString(_cacheKey);
      if(jsonString != null){
        return UserProfileModel.fromJsonString(jsonString);
      }
      return null;
    }catch(e){
      return null;
    }
  }
}