// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  preferences: UserPreferences.fromJson(
    json['preferences'] as Map<String, dynamic>,
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastLogin: DateTime.parse(json['lastLogin'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'preferences': instance.preferences,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastLogin': instance.lastLogin.toIso8601String(),
};

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      timezone: json['timezone'] as String,
      greeting: json['greeting'] as bool,
      notifications: json['notifications'] as bool,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'timezone': instance.timezone,
      'greeting': instance.greeting,
      'notifications': instance.notifications,
    };
