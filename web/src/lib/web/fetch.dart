import 'dart:html';

import 'package:http/browser_client.dart';

final client = new BrowserClient();

get(String path) async {
  var url = window.location.protocol + "//" + window.location.host + path;
  var response = await client.get(url);
  return response.body;
}

getBytes(String path) async {
  var url = window.location.protocol + "//" + window.location.host + path;
  var response = await client.get(url);
  return response.bodyBytes;
}
