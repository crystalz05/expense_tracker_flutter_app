
import 'package:expenses_tracker_app/core/network/network_info.dart';
import 'package:expenses_tracker_app/features/auth/domain/user_session/user_session.dart';
import 'package:expenses_tracker_app/features/user_profile/data/data_sources/user_profile_cache_datasource.dart';
import 'package:expenses_tracker_app/features/user_profile/data/data_sources/user_profile_cache_datasource_impl.dart';
import 'package:expenses_tracker_app/features/user_profile/data/data_sources/user_profile_remote_datasource.dart';
import 'package:expenses_tracker_app/features/user_profile/data/data_sources/user_profile_remote_datasource_impl.dart';
import 'package:expenses_tracker_app/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/usecases/create_user_profile.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/usecases/delete_profile_photo.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/usecases/get_user_profile.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/usecases/update_user_profile.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/usecases/upload_profile_photo.dart';
import 'package:expenses_tracker_app/features/user_profile/presentation/bloc/user_profile_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initUserProfile(GetIt sl) async {

  //register data sources
  sl.registerLazySingleton<UserProfileRemoteDatasource>(
      ()=> UserProfileRemoteDatasourceImpl(supabaseClient: sl<SupabaseClient>())
  );

  sl.registerLazySingleton<UserProfileCacheDataSource>(
      () => UserProfileCacheDatasourceImpl(sharedPreferences: sl<SharedPreferences>())
  );

  //register repository
  sl.registerLazySingleton<UserProfileRepository>(
      () => UserProfileRepositoryImpl(
          remoteDataSource: sl(),
          cacheDataSource: sl(),
          networkInfo: sl<NetworkInfo>(),
          userSession: sl<UserSession>())
  );

  //register usecases
  sl.registerLazySingleton(()=> GetUserProfile(sl()));
  sl.registerLazySingleton(()=> UpdateUserProfile(sl()));
  sl.registerLazySingleton(()=> CreateUserProfile(sl()));
  sl.registerLazySingleton(()=> DeleteProfilePhoto(sl()));
  sl.registerLazySingleton(()=> UploadProfilePhoto(sl()));

  //bloc
  sl.registerFactory(
      () => UserProfileBloc(
          getUserProfile: sl(),
          createUserProfile: sl(),
          updateUserProfile: sl(),
          uploadProfilePhoto: sl(),
          deleteProfilePhoto: sl())
  );
}