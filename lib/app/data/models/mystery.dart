import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'mystery.g.dart';

@JsonSerializable()
class Mystery extends Equatable {
  final int index;
  final String riddle;
  final String riddleAnswerDescription;
  final String riddleAnswerImageUrl;
  final String distortedImageUrl;
  final String originalImageUrl;
  const Mystery({
    required this.index,
    required this.riddle,
    required this.riddleAnswerDescription,
    required this.riddleAnswerImageUrl,
    required this.distortedImageUrl,
    required this.originalImageUrl,
  });
  factory Mystery.fromJson(Map<String, dynamic> json) =>
      _$MysteryFromJson(json);
  Map<String, dynamic> toJson() => _$MysteryToJson(this);
  @override
  List<Object?> get props => [index, riddle];
}
