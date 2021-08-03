import 'package:collection/collection.dart';
import 'package:race_magic/model/entity/result_entity.dart';
import 'package:race_magic/model/enum/stages.dart';

class DataFormatHelper {
  DataFormatHelper._();

  static List<RacerEntry> buildTree(List<ResultEntity> results,
      {bool sortByNumbers = true}) {
    final List<RacerEntry> tree = [];
    for (final ResultEntity result in results) {

      RacerEntry? racerEntry = tree
          .firstWhereOrNull((element) => element.number == result.number);
      if (racerEntry == null) {
        racerEntry = RacerEntry(result.number);
        tree.add(racerEntry);
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

    if (sortByNumbers) {
      tree.sort((a, b) => a.number.compareTo(b.number));
    }

    return tree;
  }
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
