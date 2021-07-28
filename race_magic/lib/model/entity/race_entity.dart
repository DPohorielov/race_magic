import 'package:json_annotation/json_annotation.dart';
import 'package:race_magic/model/entity/name_entity.dart';

part 'race_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class RaceEntity extends NameEntity {
  final String id;

  RaceEntity({required String name, this.id = ''}): super(name: name);

  factory RaceEntity.fromJson(Map<String, dynamic> json) =>
      _$RaceEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RaceEntityToJson(this);
}
