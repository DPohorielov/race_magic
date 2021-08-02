import 'dart:io';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:race_magic/model/entity/result_entity.dart';
import 'package:race_magic/model/enum/categories.dart';
import 'package:race_magic/model/enum/stages.dart';
import 'package:race_magic/util/data_format_helper.dart';

class XlsHelper {
  XlsHelper._();

  static Future<File> generateResults(List<ResultEntity> results) async {
    final List<CategoryEntry> categories = DataFormatHelper.buildTree(results);
    final Excel excel = Excel.createExcel();

    for (final Categories category in Categories.values) {
      final Sheet sh = excel[category.name];
      int column = 0;
      _addHeader(sh, column++, 'Номер');
      _addHeader(sh, column++, 'Категория');
      for (final Stages stage in Stages.values) {
        _addHeader(sh, column++, '${stage.name} Время Старта');
        _addHeader(sh, column++, '${stage.name} Время Финиша');
        _addHeader(sh, column++, '${stage.name} Длительность');
      }
      _addHeader(sh, column++, 'Общая длительность');

      final CategoryEntry? categoryEntry = categories
          .firstWhereOrNull((element) => element.category == category);
      if (categoryEntry != null) {
        int row = 1;
        for (final RacerEntry racerEntry in categoryEntry.racers) {
          _addRacer(sh, row++, racerEntry, category);
        }
      }
    }

    excel.delete('Sheet1');

    return _saveToFile(excel.save());
  }

  static void _addRacer(
      Sheet sheet, int row, RacerEntry racerEntry, Categories category) {
    int column = 0;
    _addData(sheet, column++, row, '${racerEntry.number}');
    _addData(sheet, column++, row, category.name);

    for (final Stages stage in Stages.values) {
      final StageEntry? stageEntry = racerEntry.stages
          .firstWhereOrNull((element) => element.stage == stage);

      if (stageEntry == null) {
        column += 3;
      } else {
        _addData(sheet, column++, row,
            stageEntry.start == null ? '' : buildDateString(stageEntry.start!));
        _addData(
            sheet,
            column++,
            row,
            stageEntry.finish == null
                ? ''
                : buildDateString(stageEntry.finish!));
        _addData(sheet, column++, row,
            stageEntry.time == null ? '' : printDuration(stageEntry.time!));
      }
    }

    _addData(sheet, column++, row, printDuration(racerEntry.totalTime));
  }

  static void _addHeader(Sheet sheet, int column, String value) =>
      _addData(sheet, column, 0, value, isBold: true);

  static void _addData(Sheet sheet, int column, int row, String value,
      {bool isBold = false}) {
    final Data data = sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row));
    data.value = value;
    data.cellStyle =
        CellStyle(bold: isBold, textWrapping: TextWrapping.WrapText);
  }

  static Future<File> _saveToFile(List<int>? fileBytes) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final File temp = File('$tempPath/results.xlsx');
    if (temp.existsSync()) {
      temp.deleteSync(recursive: true);
    }
    temp.createSync(recursive: true);
    if (fileBytes != null) {
      temp.writeAsBytesSync(fileBytes);
    }
    return temp;
  }

  static String printDuration(Duration duration) {
    return duration.inMilliseconds == 0
        ? '0'
        : '${duration.inMinutes}:${duration.inSeconds.remainder(60)}.${duration.inMilliseconds.remainder(1000)}';
  }

  static String buildDateString(DateTime time) {
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
}
