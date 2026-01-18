// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      id: json['id'] as String,
      teamName: json['teamName'] as String,
      mysteryOrder: (json['mysteryOrder'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      currentMysteryIndex: (json['currentMysteryIndex'] as num?)?.toInt() ?? 0,
      currentPart:
          $enumDecodeNullable(_$MysteryPartEnumMap, json['currentPart']) ??
              MysteryPart.riddle,
    );

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'id': instance.id,
      'teamName': instance.teamName,
      'currentMysteryIndex': instance.currentMysteryIndex,
      'currentPart': _$MysteryPartEnumMap[instance.currentPart]!,
      'mysteryOrder': instance.mysteryOrder,
    };

const _$MysteryPartEnumMap = {
  MysteryPart.riddle: 'riddle',
  MysteryPart.imageTask: 'imageTask',
};
