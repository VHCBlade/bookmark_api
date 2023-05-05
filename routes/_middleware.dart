import 'package:bookmark_models/bookmark_requests.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_cors/dart_frog_cors.dart';
import 'package:event_bloc/event_bloc.dart';
import 'package:event_db/event_db.dart';
import 'package:event_hive/base_event_hive.dart';

import '../models/log.dart';
import '../models/repository.dart';

Handler middleware(Handler handler) {
  const isDevelopmentMode = bool.fromEnvironment('dart.vm.product') == false;
  return repositoryLayer(
    handler
        .use(requestLogger())
        .use(
          (handler) => (context) => requestLogger(
                logger: (log, isError) async =>
                    await context.read<DatabaseRepository>().saveModel(
                          logDBNow,
                          LogModel.fromLog(log: log, isError: isError),
                        ),
              )(handler)(context),
        )
        .use(
          cors(
            allowOrigin: !isDevelopmentMode
                ? 'https://vhcblade.com, https://*.vhcblade.com, http://*.vhcblade.com'
                : CorsDefaults.allowOrigin,
          ),
        ),
  );
}

final HiveRepository repository = HiveRepository(
  typeAdapters: [
    GenericTypeAdapter<LogModel>(LogModel.new, (p0) => 1, true),
    GenericTypeAdapter<BookmarkShareRequest>(
      BookmarkShareRequest.new,
      (p0) => 2,
      true,
    ),
  ],
)..initialize(BlocEventChannel());

Handler repositoryLayer(Handler handler) {
  return handler.use(
    provider<DatabaseRepository>((handler) => repository),
  );
}
