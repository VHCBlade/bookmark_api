import 'package:event_db/event_db.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

const logDB = 'Logs';

String get logDBNow => '$logDB-${DateFormat('yyyy-MM').format(DateTime.now())}';

class LogModel extends GenericModel {
  LogModel();

  LogModel.fromLog({required this.log, required this.isError})
      : dateTime = DateTime.now();

  DateTime? dateTime;
  String? log;
  bool isError = false;

  @override
  // ignore: strict_raw_type
  Map<String, Tuple2<Getter, Setter>> getGetterSetterMap() => {
        'dateTime':
            GenericModel.dateTime(() => dateTime, (value) => dateTime = value),
        'log': GenericModel.primitive(() => log, (value) => log = value),
        'isError': GenericModel.primitive(
          () => isError,
          (value) => isError = value ?? false,
        ),
      };

  @override
  String prefixTypeForId(String idSuffix) {
    return dateTime == null
        ? super.prefixTypeForId(idSuffix)
        : 'LogModel::${dateTime!.year}-${dateTime!.month}::$idSuffix';
  }

  @override
  String get type => 'LogModel';
}
