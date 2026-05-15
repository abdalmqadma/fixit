import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const apiKey = "";
  static Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "user", "content": message},
        ],
      }),
    );

    final data = jsonDecode(response.body);
    return data["choices"][0]["message"]["content"];
  }
}
