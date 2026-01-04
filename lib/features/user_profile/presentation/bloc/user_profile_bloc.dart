import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/user_profile/presentation/bloc/user_profile_event.dart';
import 'package:expenses_tracker_app/features/user_profile/presentation/bloc/user_profile_state.dart';
import 'package:floor/floor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_user_profile.dart';
import '../../domain/usecases/delete_profile_photo.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/upload_profile_photo.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {

  final GetUserProfile getUserProfile;
  final CreateUserProfile createUserProfile;
  final UpdateUserProfile updateUserProfile;
  final UploadProfilePhoto uploadProfilePhoto;
  final DeleteProfilePhoto deleteProfilePhoto;

  UserProfileBloc({
    required this.getUserProfile,
    required this.createUserProfile,
    required this.updateUserProfile,
    required this.uploadProfilePhoto,
    required this.deleteProfilePhoto
  }): super(const UserProfileInitial()){
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<CreateUserProfileEvent>(_onCreateUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<UploadProfilePhotoEvent>(_onUploadProfilePhoto);
    on<DeleteProfilePhotoEvent>(_onDeleteProfilePhoto);
    on<ResetUserProfile>(_onResetUserProfile);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfileEvent event,
      Emitter<UserProfileState> emit,
      ) async {

    emit(const UserProfileLoading());

    final result = await getUserProfile(NoParams());

    result.fold(
        (failure) => emit(UserProfileError(failure.message)),
        (profile) => emit(UserProfileLoaded(profile))
    );
  }

  Future<void> _onCreateUserProfile(
      CreateUserProfileEvent event,
      Emitter<UserProfileState> emit,
      ) async {
    emit(const UserProfileLoading());

    final result = await createUserProfile(event.profile);

    result.fold(
        (failure) => emit(UserProfileError(failure.message)),
        (profile) => emit(UserProfileLoaded(profile))
    );
  }
  Future<void> _onUpdateUserProfile(
      UpdateUserProfileEvent event,
      Emitter<UserProfileState> emit
      ) async {
    emit(const UserProfileLoading());

    final result = await updateUserProfile(event.profile);

    result.fold(
        (failure) => emit(UserProfileError(failure.message)),
        (profile) => emit(UserProfileUpdated(profile))
    );
  }

  Future<void> _onUploadProfilePhoto(
      UploadProfilePhotoEvent event,
      Emitter<UserProfileState> emit
      ) async {
    emit(const UserProfilePhotoUploading());

    final result = await uploadProfilePhoto(event.photoFile);

    result.fold(
        (failure) => emit(UserProfileError(failure.message)),
        (profile) => emit(UserProfilePhotoUploaded(profile.profilePhotoUrl))
    );
  }

  Future<void> _onDeleteProfilePhoto(
      DeleteProfilePhotoEvent event,
      Emitter<UserProfileState> emit
      ) async {
    emit(const UserProfileLoading());

    final result = await deleteProfilePhoto(event.photoUrl);

    result.fold(
        (failure) => emit(UserProfileError(failure.message)),
        (_) => add(LoadUserProfileEvent())
    );
  }

  Future<void> _onResetUserProfile(
      ResetUserProfile event,
      Emitter<UserProfileState> emit,
      ) async {
    emit(const UserProfileInitial());
  }
}