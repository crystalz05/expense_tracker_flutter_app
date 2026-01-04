import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {

  final String userId;
  final String? profilePhotoUrl;
  final String? phoneNumber;
  final DateTime createAt;
  final DateTime? updatedAt;


  const UserProfile({
    required this.userId,
    this.profilePhotoUrl,
    this.phoneNumber,
    required this.createAt,
    this.updatedAt
  });


  @override
  // TODO: implement props
  List<Object?> get props => [userId, profilePhotoUrl, phoneNumber, createAt, updatedAt];

}