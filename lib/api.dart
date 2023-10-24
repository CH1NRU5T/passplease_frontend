import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  static Future<(String?, dynamic)> post(
      String url, Map<String, dynamic> reqBody) async {
    try {
      http.Response res = await http.post(
        Uri.parse(url),
        body: jsonEncode(reqBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print(res.body);
      dynamic body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return (null, body);
      }
      return (body['error'] as String, null);
    } catch (e) {
      return (e.toString(), null);
    }
  }
}
