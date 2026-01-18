// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Submission _$SubmissionFromJson(Map<String, dynamic> json) => Submission(
      teamId: json['teamId'] as String,
      teamName: json['teamName'] as String,
      mysteryIndex: (json['mysteryIndex'] as num).toInt(),
      part: $enumDecode(_$MysteryPartEnumMap, json['part']),
      imageUrl: json['imageUrl'] as String,
      timestamp:
          const TimestampConverter().fromJson(json['timestamp'] as Timestamp),
      status: json['status'] as String? ?? 'pending',
    );

Map<String, dynamic> _$SubmissionToJson(Submission instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'teamName': instance.teamName,
      'mysteryIndex': instance.mysteryIndex,
      'part': _$MysteryPartEnumMap[instance.part]!,
      'imageUrl': instance.imageUrl,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
      'status': instance.status,
    };

const _$MysteryPartEnumMap = {
  MysteryPart.riddle: 'riddle',
  MysteryPart.imageTask: 'imageTask',
};
