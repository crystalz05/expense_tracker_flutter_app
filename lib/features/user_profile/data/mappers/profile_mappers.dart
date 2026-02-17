import 'package:expenses_tracker_app/features/user_profile/data/models/user_profile_model.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/entities/user_profile.dart';

extension UserProfileModelMapper on UserProfileModel {
  UserProfile toEntity() {
    return UserProfile(
      userId: userId,
      profilePhotoUrl: profilePhotoUrl,
      phoneNumber: phoneNumber,
      createAt: createAt,
      updatedAt: updatedAt,
    );
  }
}

extension UserProfileEntityMapper on UserProfile {
  UserProfileModel toModel() {
    return UserProfileModel(
      userId: userId,
      profilePhotoUrl: profilePhotoUrl,
      phoneNumber: phoneNumber,
      createAt: createAt,
      updatedAt: updatedAt,
    );
  }
}
