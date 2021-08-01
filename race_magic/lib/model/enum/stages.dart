import 'package:json_annotation/json_annotation.dart';

enum Stages {
  @JsonValue(0)
  stage0,
  @JsonValue(1)
  stage1,
  @JsonValue(2)
  stage2,
  @JsonValue(3)
  stage3
}

extension StagesExtension on Stages {
  String get name {
    switch (this) {
      case Stages.stage0:
        return 'CУ 1';
      case Stages.stage1:
        return 'CУ 2';
      case Stages.stage2:
        return 'CУ 3';
      case Stages.stage3:
        return 'CУ 4';
    }
  }

  int get val {
    switch (this) {
      case Stages.stage0:
        return 0;
      case Stages.stage1:
        return 1;
      case Stages.stage2:
        return 2;
      case Stages.stage3:
        return 3;
    }
  }
}
