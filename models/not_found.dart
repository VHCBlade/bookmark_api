import 'package:dart_frog/dart_frog.dart';

Response notFoundResponse() {
  return Response(statusCode: 404, body: 'Route not found');
}
