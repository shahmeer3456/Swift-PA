// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
  id: json['id'] as String,
  userId: json['userId'] as String,
  content: json['content'] as String,
  title: json['title'] as String?,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  isImportant: json['isImportant'] as bool,
  category: json['category'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'content': instance.content,
  'title': instance.title,
  'tags': instance.tags,
  'isImportant': instance.isImportant,
  'category': instance.category,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
