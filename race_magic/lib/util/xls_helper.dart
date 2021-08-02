import 'package:race_magic/model/entity/result_entity.dart';
import 'package:race_magic/util/data_format_helper.dart';

class XlsHelper {
  XlsHelper._(){}

  static void generateResults(List<ResultEntity> results) {
    final List<CategoryEntry> categories = DataFormatHelper.buildTree(results);
    print(categories);
  }
}

