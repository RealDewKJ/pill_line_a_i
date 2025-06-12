import 'package:http/http.dart' as http;

Future<http.Response> sendLineNotify(String accessToken, String message) async {
  final response = await http.post(
    Uri.parse('https://notify-api.line.me/api/notify'),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken',
    },
    body: {
      'message': message,
    },
  );
  return response;
}
