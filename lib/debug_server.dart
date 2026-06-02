import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'dart:convert';
import 'package:medstock/config/database/user_dbhelper.dart';
import 'package:medstock/config/database/product_dbhelper.dart';

Future<void> startDebugServer() async {
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final server = await shelf_io.serve(handler, '0.0.0.0', 8080);
  debugPrint('Debug server running on https://${server.address.host}:${server.port}');
}

Response _addCorsHeaders(Response response) {
  return response.change(headers: {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  });
}

Future<Response> _router(Request request) async {
  if (request.method == 'OPTIONS') {
    return _addCorsHeaders(Response.ok(''));
  }

  final userdbHelper = UserDatabaseHelper();
  final userdb = await userdbHelper.database;

  if (request.url.path == 'users') {
    final users = await userdbHelper.getUsers();
    final jsonList = users.map((p) => p.toMap()).toList();
    return _addCorsHeaders(Response.ok(
      jsonEncode(jsonList),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  final productdbHelper = ProductDatabaseHelper();

  if (request.url.path == 'products') {
    final products = await productdbHelper.getProducts();
    final jsonList = products.map((p) => p.toMap()).toList();
    return _addCorsHeaders(Response.ok(
      jsonEncode(jsonList),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  if (request.url.path == 'all-tables') {
    final tables = await userdb.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
    );
    final result = <String, dynamic>{};
    for (final table in tables) {
      final tableName = table['name'] as String;
      final rows = await userdb.rawQuery('SELECT * FROM $tableName');
      result[tableName] = rows;
    }
    return _addCorsHeaders(Response.ok(
      jsonEncode(result),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  return _addCorsHeaders(Response.notFound('Not Found'));
}