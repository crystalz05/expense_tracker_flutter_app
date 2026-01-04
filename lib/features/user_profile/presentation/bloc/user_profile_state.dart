
import 'package:equatable/equatable.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/entities/user_profile.dart';

class UserProfileState extends Equatable{

  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState{
  const UserProfileInitial();
}

class UserProfileLoading extends UserProfileState{
  const UserProfileLoading();
}

class UserProfileLoaded extends UserProfileState{

  final UserProfile profile;

  const UserProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class UserProfilePhotoUploading extends UserProfileState {
  const UserProfilePhotoUploading();
}

class UserProfilePhotoUploaded extends UserProfileState {
  final String? photoUrl;

  const UserProfilePhotoUploaded(this.photoUrl);

  @override
  List<Object?> get props => [photoUrl];
}

class UserProfileUpdated extends UserProfileState {
  final UserProfile profile;

  const UserProfileUpdated(this.profile);

  @override
  List<Object?> get props => [profile];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

