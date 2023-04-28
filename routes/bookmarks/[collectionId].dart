import 'dart:convert';

import 'package:bookmark_models/bookmark_requests.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:event_db/event_db.dart';

import '../../models/not_found.dart';
import 'index.dart';

Future<Response> onRequest(RequestContext context, String collectionId) async {
  switch (context.request.method) {
    case HttpMethod.put:
      return putResponse(context, collectionId);
    case HttpMethod.post:
      return postResponse(context, collectionId);
    // ignore: no_default_cases
    default:
      return notFoundResponse();
  }
}

Future<Response> putResponse(
  RequestContext context,
  String collectionId,
) async {
  final body = await context.request.body();
  final bookmarkShareRequest = BookmarkShareRequest();
  try {
    bookmarkShareRequest.loadFromMap(json.decode(body) as Map<String, dynamic>);
  } on Object {
    return Response(statusCode: 400, body: 'Syntax Error for Request');
  }
  final database = context.read<DatabaseRepository>();

  final fullId = (BookmarkCollectionModel()..idSuffix = collectionId).id!;
  final foundModel =
      await database.findModel<BookmarkShareRequest>(fullId, shareRequestId);
  if (foundModel == null ||
      foundModel.profile != bookmarkShareRequest.profile ||
      fullId != bookmarkShareRequest.collectionModel.id) {
    return notFoundResponse();
  }
  bookmarkShareRequest.id = shareRequestId;
  database.saveModel(collectionId, bookmarkShareRequest);

  return Response(body: collectionId);
}

Future<Response> postResponse(
  RequestContext context,
  String collectionId,
) async {
  final body = await context.request.body();
  final syncRequest = BookmarkSyncRequest();
  try {
    syncRequest.loadFromMap(json.decode(body) as Map<String, dynamic>);
  } on Object {
    return Response(statusCode: 400, body: 'Syntax Error for Request');
  }
  if (syncRequest.collectionId != collectionId) {
    return notFoundResponse();
  }
  final fullId = (BookmarkCollectionModel()..idSuffix = collectionId).id!;
  final database = context.read<DatabaseRepository>();

  final foundModel =
      await database.findModel<BookmarkShareRequest>(fullId, shareRequestId);
  if (foundModel == null) {
    return notFoundResponse();
  }
  final collectionModel = foundModel.collectionModel;
  final syncData = BookmarkSyncData()
    ..updated = collectionModel.lastEdited.microsecondsSinceEpoch !=
        syncRequest.lastUpdated?.microsecondsSinceEpoch
    ..lastUpdated = collectionModel.lastEdited;

  if (syncData.updated) {
    syncData.collectionModel = collectionModel;
  }

  return Response(body: json.encode(syncData.toMap()));
}
