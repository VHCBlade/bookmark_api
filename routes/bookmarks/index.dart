import 'dart:convert';

import 'package:bookmark_models/bookmark_requests.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:event_db/event_db.dart';

import '../../models/not_found.dart';
import '../../models/repository.dart';

const shareRequestId = 'Share';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return notFoundResponse();
  }

  final body = await context.request.body();
  final bookmarkShareRequest = BookmarkShareRequest();
  late final String id;
  try {
    bookmarkShareRequest.loadFromMap(json.decode(body) as Map<String, dynamic>);
    id = bookmarkShareRequest.collectionModel.id!;
  } on Object {
    return Response(statusCode: 400, body: 'Syntax Error for Request');
  }

  final database = SpecificDatabase(context.read<DatabaseRepository>(), id);

  final foundModel = await database.findModel(shareRequestId);
  if (foundModel != null) {
    return Response(
      statusCode: 460,
      body: BookmarkErrorStatusCodes.error460.error,
    );
  }
  bookmarkShareRequest.id = shareRequestId;
  await database.saveModel(bookmarkShareRequest);
  return Response(body: getIdSuffix(id));
}
