import 'package:json_annotation/json_annotation.dart';

part 'result_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class ResultEntity{
  final String raceId;
  final int number;
  final DateTime time;
  bool isStart;

  ResultEntity(this.raceId, this.number, this.time, {required this.isStart});

  factory ResultEntity.fromJson(Map<String, dynamic> json) =>
      _$ResultEntityFromJson(json);


  Map<String, dynamic> toJson() => _$ResultEntityToJson(this);
}
