// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameStatus _$GameStatusFromJson(Map<String, dynamic> json) => GameStatus(
      startTime: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['startTime'], const TimestampConverter().fromJson),
      endTime: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['endTime'], const TimestampConverter().fromJson),
      isLeaderboardEnabled: json['isLeaderboardEnabled'] as bool,
    );

Map<String, dynamic> _$GameStatusToJson(GameStatus instance) =>
    <String, dynamic>{
      'startTime': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.startTime, const TimestampConverter().toJson),
      'endTime': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.endTime, const TimestampConverter().toJson),
      'isLeaderboardEnabled': instance.isLeaderboardEnabled,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
