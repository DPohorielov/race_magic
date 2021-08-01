// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultEntity _$ResultEntityFromJson(Map<String, dynamic> json) {
  return ResultEntity(
    json['number'] as int,
    DateTime.parse(json['time'] as String),
    _$enumDecode(_$StagesEnumMap, json['stage']),
    _$enumDecode(_$CategoriesEnumMap, json['category']),
    isStart: json['isStart'] as bool,
  );
}

Map<String, dynamic> _$ResultEntityToJson(ResultEntity instance) =>
    <String, dynamic>{
      'stage': _$StagesEnumMap[instance.stage],
      'category': _$CategoriesEnumMap[instance.category],
      'number': instance.number,
      'time': instance.time.toIso8601String(),
      'isStart': instance.isStart,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$StagesEnumMap = {
  Stages.stage0: 0,
  Stages.stage1: 1,
  Stages.stage2: 2,
  Stages.stage3: 3,
};

const _$CategoriesEnumMap = {
  Categories.elite: 0,
  Categories.masters: 1,
  Categories.women: 2,
  Categories.ebike: 3,
};
