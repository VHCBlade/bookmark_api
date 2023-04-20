import 'dart:convert';

import 'package:bookmark_models/bookmark_requests.dart';

void main() {
  final request = BookmarkSyncRequest()
    ..collectionId = 'Amazing'
    ..lastUpdated = null;

  // ignore: avoid_print
  print(json.encode(request.toMap()));
}
