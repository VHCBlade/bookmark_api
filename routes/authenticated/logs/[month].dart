import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:event_db/event_db.dart';
import 'package:intl/intl.dart';

import '../../../auth/password.dart';
import '../../../models/log.dart';

DateTime? parseYearMonth(String input) {
  try {
    return DateFormat('yyyy-MM').parseStrict(input);
  } catch (e) {
    return null;
  }
}

Future<Response> onRequest(RequestContext context, String month) async {
  final response = await context.authenticate(await context.request.body());
  if (response != null) {
    return response;
  }

  final yearMonth = parseYearMonth(month);
  if (yearMonth == null) {
    return Response(
        statusCode: HttpStatus.badRequest, body: 'The given format is wrong');
  }
  final models = await context.read<DatabaseRepository>().findAllModelsOfType(
        '$logDB-$month',
        () => LogModel()..dateTime = yearMonth,
      );
  return Response(
    body: json.encode(models.map((e) => e.toMap()).toList()),
  );
}
