import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/entities/user_profile.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfileEvent extends UserProfileEvent {
  @override
  List<Object?> get props => [];
}

class CreateUserProfileEvent extends UserProfileEvent {
  const CreateUserProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateUserProfileEvent extends UserProfileEvent {
  final UserProfile profile;

  const UpdateUserProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}

class UploadProfilePhotoEvent extends UserProfileEvent {
  final File photoFile;

  const UploadProfilePhotoEvent(this.photoFile);

  @override
  List<Object?> get props => [photoFile];
}

class DeleteProfilePhotoEvent extends UserProfileEvent {
  final String photoUrl;

  const DeleteProfilePhotoEvent(this.photoUrl);

  @override
  List<Object?> get props => [photoUrl];
}

class ResetUserProfile extends UserProfileEvent {
  const ResetUserProfile();
}
