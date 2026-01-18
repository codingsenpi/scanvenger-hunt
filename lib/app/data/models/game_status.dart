import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'game_status.g.dart';
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();
  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();
  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
@JsonSerializable()
class GameStatus extends Equatable {
  @TimestampConverter()
  final DateTime? startTime;
  @TimestampConverter()
  final DateTime? endTime;
  final bool isLeaderboardEnabled;
  const GameStatus({
    this.startTime,
    this.endTime,
    required this.isLeaderboardEnabled,
  });
  factory GameStatus.fromJson(Map<String, dynamic> json) =>
      _$GameStatusFromJson(json);
  Map<String, dynamic> toJson() => _$GameStatusToJson(this);
  @override
  List<Object?> get props => [startTime, endTime, isLeaderboardEnabled];
}
