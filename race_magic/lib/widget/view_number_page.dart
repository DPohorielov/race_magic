import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:race_magic/model/entity/result_entity.dart';
import 'package:race_magic/model/enum/categories.dart';
import 'package:race_magic/model/enum/stages.dart';

class ViewNumberPage extends StatefulWidget {
  final List<ResultEntity> results;
  final String raceId;

  const ViewNumberPage({Key? key, required this.results, required this.raceId})
      : super(key: key);

  @override
  State<ViewNumberPage> createState() => _ViewNumberPageState();
}

class _ViewNumberPageState extends State<ViewNumberPage> {
  //bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final Map<Stages, List<ResultEntity>> stagesMap = {};
    for (final ResultEntity result in widget.results) {
      if (stagesMap[result.stage] == null) {
        stagesMap[result.stage] = [result];
      } else {
        stagesMap[result.stage]!.add(result);
      }
    }

    final List<StageResult> stages = [];
    for (int i = 0; i < Stages.values.length; i++) {
      final result =
          StageResult.fromList(Stages.values[i], stagesMap[Stages.values[i]]);
      stages.add(result);
    }

    Duration total = const Duration();
    for (final StageResult stageResult in stages) {
      final Duration? time = stageResult.time;
      if (time != null) {
        total += time;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Участник #${widget.results.first.number} ${widget.results.first.category.name}'),
        /*    actions: [
          if (_isDeleting)
            const Padding(
              padding: EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
                right: 16.0,
              ),
              child: CircularProgressIndicator(),
            )
          else
            IconButton(
              icon: const Icon(
                Icons.delete,
                size: 32,
              ),
              onPressed: () => _showDeleteDialog(),
            ),
        ],*/
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: stages.length,
                    itemBuilder: (context, index) {
                      final StageResult stageResult = stages[index];
                      final Duration? time = stageResult.time;
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stageResult.stage.name,
                              style: const TextStyle(
                                fontSize: 20.0,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (time != null)
                              Text(
                                'Длительность: ${_printDuration(time)}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            const SizedBox(height: 6.0),
                            Text(
                              'Время Старта: ${stageResult.start == null ? '' : ' ${buildDateString(stageResult.start!)}'}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              'Время Финиша: ${stageResult.finish == null ? '' : ' ${buildDateString(stageResult.finish!)}'}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                letterSpacing: 1,
                              ),
                            ),
                          ]);
                    }),
                const Divider(),
                const SizedBox(height: 6.0),
                Text(
                  'Общая Длительность: ${_printDuration(total)}',
                  style: const TextStyle(
                    fontSize: 24.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*void _showDeleteDialog() {
    final Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop(false);
      },
      child: const Text('Cancel'),
    );
    final Widget continueButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop(true);
      },
      child: const Text('Delete'),
    );

    final AlertDialog alert = AlertDialog(
      title: const Text('Are you sure you want delete racer?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    ).then((value) async {
      if (value is bool && value) {
        setState(() {
          _isDeleting = true;
        });

        await Repository.deleteRacer(
            widget.results.first.number, widget.raceId);

        setState(() {
          _isDeleting = false;
        });

        Navigator.of(context).pop();
      }
    });
  }*/
}

String _printDuration(Duration duration) {
  return duration.inMilliseconds == 0
      ? '0'
      : '${duration.inMinutes}:${duration.inSeconds.remainder(60)}.${duration.inMilliseconds.remainder(1000)}';
}

String buildDateString(DateTime time) {
  final int ms = time.millisecond;

  final StringBuffer msString = StringBuffer();

  if (ms < 10) {
    msString.write('0');
  }
  if (ms < 100) {
    msString.write('0');
  }
  msString.write(ms);
  return '${DateFormat('hh:mm:ss').format(time)}.$msString';
}

class StageResult {
  final Stages stage;
  final DateTime? start;
  final DateTime? finish;

  StageResult(this.stage, {this.start, this.finish});

  factory StageResult.fromList(Stages stage, List<ResultEntity>? list) {
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

    return StageResult(stage, start: start, finish: finish);
  }

  Duration? get time {
    if (start != null && finish != null) {
      return finish!.difference(start!);
    }

    return null;
  }
}
