import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

import '../../../../core/utils/date_time_converter.dart';
import '../../domain/entities/user_profile.dart';

@TypeConverters([DateTimeConverter, NullableDateTimeConverter])
@Entity(tableName: "user_profiles")
class UserProfileModel{

  @primaryKey
  @ColumnInfo(name: 'user_id')
  final String userId;

  @ColumnInfo(name: 'profile_photo_url')
  final String? profilePhotoUrl;

  @ColumnInfo(name: 'phone_number')
  final String? phoneNumber;

  @ColumnInfo(name: 'create_at')
  final DateTime createAt;

  @ColumnInfo(name: 'updated_at')
  final DateTime? updatedAt;

  UserProfileModel({
    required this.userId,
    this.profilePhotoUrl,
    this.phoneNumber,
    required this.createAt,
    this.updatedAt
  });


  Map<String, dynamic> toJson(){
    return {
      'user_id': userId,
      'profile_photo_url': profilePhotoUrl,
      'phone_number': phoneNumber,
      'created_at': createAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String()
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json){
    return UserProfileModel(
        userId: json['user_id'] as String,
        profilePhotoUrl: json['profile_photo_url'] as String?,
        phoneNumber: json['phone_number'] as String?,
        createAt: DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      userId: profile.userId,
      profilePhotoUrl: profile.profilePhotoUrl,
      phoneNumber: profile.phoneNumber,
      updatedAt: profile.updatedAt,
      createAt: profile.createAt,
    );
  }

  UserProfileModel copyWith({
    String? userId,
    String? profilePhotoUrl,
    String? phoneNumber,
    DateTime? createAt,
    DateTime? updatedAt,
  }){
    return UserProfileModel(
        userId: userId ?? this.userId,
        profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        createAt: createAt ?? this.createAt,
        updatedAt: updatedAt ?? this.updatedAt
    );
  }

  //For caching
  String toJsonString() => jsonEncode(toJson());

  factory UserProfileModel.fromJsonString(String jsonString){
    return UserProfileModel.fromJson(jsonDecode(jsonString));
  }

}