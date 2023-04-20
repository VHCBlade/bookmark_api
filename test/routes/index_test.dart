import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/index.dart' as route;

class MockRequestContext extends Mock implements RequestContext {
  MockRequestContext(this.request);

  @override
  final Request request;
}

void main() {
  group('GET /', () {
    test('responds with a 200 and "Good".', () {
      final context = MockRequestContext(Request.get(Uri.parse('/')));
      final response = route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.body(),
        completion(equals('Good')),
      );
    });
  });
}
