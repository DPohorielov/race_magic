// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultEntity _$ResultEntityFromJson(Map<String, dynamic> json) {
  return ResultEntity(
    json['number'] as int,
    DateTime.parse(json['time'] as String),
    json['stage'] as int,
    isStart: json['isStart'] as bool,
  );
}

Map<String, dynamic> _$ResultEntityToJson(ResultEntity instance) =>
    <String, dynamic>{
      'stage': instance.stage,
      'number': instance.number,
      'time': instance.time.toIso8601String(),
      'isStart': instance.isStart,
    };
