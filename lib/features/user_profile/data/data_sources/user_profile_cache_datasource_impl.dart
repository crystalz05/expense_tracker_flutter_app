
import 'package:expenses_tracker_app/features/user_profile/data/data_sources/user_profile_cache_datasource.dart';
import 'package:expenses_tracker_app/features/user_profile/data/models/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileCacheDatasourceImpl implements UserProfileCacheDataSource {

  final SharedPreferences sharedPreferences;
  static const String _cacheKey = 'cached_user_profile';

  UserProfileCacheDatasourceImpl({required this.sharedPreferences});


  @override
  Future<void> cacheProfile(UserProfileModel profile) {
    // TODO: implement cacheProfile
    throw UnimplementedError();
  }

  @override
  Future<void> clearCache() {
    // TODO: implement clearCache
    throw UnimplementedError();
  }

  @override
  Future<UserProfileModel?> getCachedProfile(String userId) {
    // TODO: implement getCachedProfile
    throw UnimplementedError();
  }

}