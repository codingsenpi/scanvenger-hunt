import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'team.dart';
part 'submission.g.dart';
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();
  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();
  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
@JsonSerializable()
class Submission extends Equatable {
  final String teamId;
  final String teamName;
  final int mysteryIndex;
  final MysteryPart part;
  final String imageUrl;
  @TimestampConverter()
  final DateTime timestamp;
  final String status;
  const Submission({
    required this.teamId,
    required this.teamName,
    required this.mysteryIndex,
    required this.part,
    required this.imageUrl,
    required this.timestamp,
    this.status = 'pending',
  });
  factory Submission.fromJson(Map<String, dynamic> json) =>
      _$SubmissionFromJson(json);
  Map<String, dynamic> toJson() => _$SubmissionToJson(this);
  @override
  List<Object?> get props => [teamId, mysteryIndex, part, timestamp];
}
