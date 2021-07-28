import 'package:json_annotation/json_annotation.dart';

part 'name_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class NameEntity {
  final String name;

  NameEntity({required this.name});

  factory NameEntity.fromJson(Map<String, dynamic> json) =>
      _$NameEntityFromJson(json);

  Map<String, dynamic> toJson() => _$NameEntityToJson(this);
}
