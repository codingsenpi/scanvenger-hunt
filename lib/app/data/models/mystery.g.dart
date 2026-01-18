// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mystery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mystery _$MysteryFromJson(Map<String, dynamic> json) => Mystery(
      index: (json['index'] as num).toInt(),
      riddle: json['riddle'] as String,
      riddleAnswerDescription: json['riddleAnswerDescription'] as String,
      riddleAnswerImageUrl: json['riddleAnswerImageUrl'] as String,
      distortedImageUrl: json['distortedImageUrl'] as String,
      originalImageUrl: json['originalImageUrl'] as String,
    );

Map<String, dynamic> _$MysteryToJson(Mystery instance) => <String, dynamic>{
      'index': instance.index,
      'riddle': instance.riddle,
      'riddleAnswerDescription': instance.riddleAnswerDescription,
      'riddleAnswerImageUrl': instance.riddleAnswerImageUrl,
      'distortedImageUrl': instance.distortedImageUrl,
      'originalImageUrl': instance.originalImageUrl,
    };
