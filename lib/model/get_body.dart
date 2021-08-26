import 'dart:convert';
import 'dart:io';

// 各所で扱えるようにするため、Singleton パターンで記述している
class GetBody {
  factory GetBody() => _instance;
  GetBody._internal();
  static final GetBody _instance = GetBody._internal();

  Future<String> getBody(String url) async {
    try {
      final reqest = await HttpClient().getUrl(Uri.parse(url));
      final response = await reqest.close();
      return _parseResponse(
          response.statusCode, await utf8.decodeStream(response));
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }

  String _parseResponse(int httpStatus, String responseBody) {
    switch (httpStatus) {
      case 200:
        return responseBody;
      default:
        throw Exception('$httpStatus');
    }
  }
}
