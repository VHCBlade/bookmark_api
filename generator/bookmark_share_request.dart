import 'dart:convert';

import 'package:bookmark_models/bookmark_requests.dart';

void main() {
  final request = BookmarkShareRequest()
    ..profile = 'Amazing'
    ..collectionModel = (BookmarkCollectionModel()
      ..autoGenId
      ..bookmarkName = 'Generated');

  // ignore: avoid_print
  print(json.encode(request.toMap()));
}
