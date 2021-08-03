import 'package:json_annotation/json_annotation.dart';
import 'package:race_magic/model/enum/stages.dart';

part 'result_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class ResultEntity {
  final Stages stage;
  final int number;
  final DateTime time;
  bool isStart;

  ResultEntity(this.number, this.time, this.stage, {required this.isStart});

  factory ResultEntity.fromJson(Map<String, dynamic> json) =>
      _$ResultEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ResultEntityToJson(this);
}
