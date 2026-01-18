import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'team.g.dart';
enum MysteryPart { riddle, imageTask }
@JsonSerializable()
class Team extends Equatable {
  final String id;
  final String teamName;
  final int
      currentMysteryIndex;
  final MysteryPart currentPart;
  final List<int> mysteryOrder;
  const Team({
    required this.id,
    required this.teamName,
    required this.mysteryOrder,
    this.currentMysteryIndex = 0,
    this.currentPart = MysteryPart.riddle,
  });
  int get score => currentMysteryIndex;
  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
  @override
  List<Object?> get props =>
      [id, teamName, currentMysteryIndex, currentPart, mysteryOrder];
}
