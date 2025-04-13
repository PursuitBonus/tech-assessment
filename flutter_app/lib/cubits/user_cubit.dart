import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfile {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String country;
  final String avatarAsset;
  final DateTime joinedAt;
  final List<String> withdrawalAccounts;

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.country,
    required this.avatarAsset,
    required this.joinedAt,
    required this.withdrawalAccounts,
  });
}

class UserCubit extends Cubit<UserProfile> {
  UserCubit()
      : super(UserProfile(
    userId: 'user',
    name: 'John Doe',
    email: 'john@example.com',
    phone: '+358 123 4567',
    country: 'Finland',
    avatarAsset: 'assets/avatar_placeholder.png',
    joinedAt: DateTime(2024, 1, 1),
    withdrawalAccounts: [
      'Visa **** 4242',
      'Revolut **** 8834',
      'Bank Account **** 1971',
    ],
  ));
}
