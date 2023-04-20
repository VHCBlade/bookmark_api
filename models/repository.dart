import 'package:event_hive/base_event_hive.dart';
import 'package:hive/hive.dart';

String getIdSuffix(String id) {
  return id.split('::').last;
}

class HiveRepository extends BaseHiveRepository {
  HiveRepository({required super.typeAdapters});

  @override
  void initializeEngine() {
    Hive.init('../bookmark_api_hive/');
  }

  @override
  // ignore: strict_raw_type
  Future<LazyBox> openBox(String database) async {
    return Hive.openLazyBox(database);
  }
}
