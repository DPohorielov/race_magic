import 'package:collection/collection.dart';
import 'package:race_magic/model/entity/result_entity.dart';
import 'package:race_magic/model/enum/categories.dart';
import 'package:race_magic/model/enum/stages.dart';

class DataFormatHelper {
  DataFormatHelper._();

  static List<CategoryEntry> buildTree(List<ResultEntity> results,
      {bool sortByTotal = true}) {
    final List<CategoryEntry> tree = [];
    for (final ResultEntity result in results) {
      CategoryEntry? categoryEntry = tree
          .firstWhereOrNull((element) => element.category == result.category);
      if (categoryEntry == null) {
        categoryEntry = CategoryEntry(result.category);
        tree.add(categoryEntry);
      }

      RacerEntry? racerEntry = categoryEntry.racers
          .firstWhereOrNull((element) => element.number == result.number);
      if (racerEntry == null) {
        racerEntry = RacerEntry(result.number);
        categoryEntry.racers.add(racerEntry);
      }

      StageEntry? stageEntry = racerEntry.stages
          .firstWhereOrNull((element) => element.stage == result.stage);
      if (stageEntry == null) {
        stageEntry = StageEntry(result.stage);
        racerEntry.stages.add(stageEntry);
      }
      if (result.isStart) {
        stageEntry.start = result.time;
      } else {
        stageEntry.finish = result.time;
      }
    }

    if (sortByTotal) {
      for(final CategoryEntry categoryEntry in tree) {
        categoryEntry.racers.sort((a, b) => a.totalTime.compareTo(b.totalTime));
      }
    }

    return tree;
  }
}

class CategoryEntry {
  final Categories category;
  final List<RacerEntry> racers = [];

  CategoryEntry(this.category);
}

class RacerEntry {
  final int number;
  final List<StageEntry> stages = [];
  Duration? _total;

  RacerEntry(this.number);

  Duration get totalTime {
    if (_total == null) {
      _total = const Duration();
      for (final StageEntry stageEntry in stages) {
        final Duration? time = stageEntry.time;
        if (time != null) {
          _total = _total! + time;
        }
      }
    }

    return _total!;
  }
}

class StageEntry {
  final Stages stage;
  DateTime? start;
  DateTime? finish;

  StageEntry(this.stage, {this.start, this.finish});

  factory StageEntry.fromList(Stages stage, List<ResultEntity>? list) {
    DateTime? start;
    DateTime? finish;

    if (list != null) {
      for (final ResultEntity resultEntity in list) {
        if (resultEntity.isStart) {
          start = resultEntity.time;
        } else {
          finish = resultEntity.time;
        }
      }
    }

    return StageEntry(stage, start: start, finish: finish);
  }

  Duration? get time {
    if (start != null && finish != null) {
      return finish!.difference(start!);
    }

    return null;
  }
}
