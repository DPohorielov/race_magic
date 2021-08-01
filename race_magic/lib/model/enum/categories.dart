import 'package:json_annotation/json_annotation.dart';

enum Categories {
  @JsonValue(0)
  elite,
  @JsonValue(1)
  masters,
  @JsonValue(2)
  women,
  @JsonValue(3)
  ebike,
}

extension CategoriesExtension on Categories {
  String get name {
    switch (this) {
      case Categories.elite:
        return 'Элита';
      case Categories.masters:
        return 'Мастера';
      case Categories.women:
        return 'Девушки';
      case Categories.ebike:
        return 'E-bike';
    }
  }

  int get val {
    switch (this) {
      case Categories.elite:
        return 0;
      case Categories.masters:
        return 1;
      case Categories.women:
        return 2;
      case Categories.ebike:
        return 3;
    }
  }
}
