import 'package:dart_frog/dart_frog.dart';
import 'package:event_bloc/event_bloc.dart';

import '../../auth/password.dart';

Handler middleware(Handler handler) {
  return handler.use(
    provider<PasswordRepository>(
      (handler) => FilePasswordRepository()..initialize(BlocEventChannel()),
    ),
  );
}
