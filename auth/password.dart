import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:event_bloc/event_bloc.dart';

import '../models/not_found.dart';

class PasswordException implements Exception {}

abstract class PasswordRepository extends Repository {
  void authenticate(String password);
}

class FilePasswordRepository extends PasswordRepository {
  @override
  void authenticate(String password) {
    final currentPassword = File('tokens/password.txt').readAsStringSync();

    if (currentPassword != password) {
      throw PasswordException();
    }
  }

  @override
  // ignore: strict_raw_type
  List<BlocEventListener> generateListeners(BlocEventChannel channel) => [];
}

extension AuthenticatorRequestContext on RequestContext {
  Future<Response?> authenticate(String password) async {
    try {
      read<PasswordRepository>().authenticate(password);
    } on PasswordException {
      return notFoundResponse();
    }

    return null;
  }
}
