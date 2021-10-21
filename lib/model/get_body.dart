import 'dart:convert';
import 'dart:io';

// Cookie 対応バージョン (上手く動作したので、Cookie用も統合済み)
// 各所で扱えるようにするため、Singleton パターンで記述している
class GetBody {
  factory GetBody() => _instance;
  GetBody._internal();
  static final GetBody _instance = GetBody._internal();

  Future<String> getBody(String url, Map<String, String> cookie) async {
    try {
      final request = await HttpClient().getUrl(Uri.parse(url));
      if (cookie.isNotEmpty) {
        cookie.forEach((key, value) => request.cookies.add(Cookie(key, value)));
      }
      final response = await request.close();
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

  // Response が欲しいという場合もあったので、追加記載
  Future<HttpClientResponse> getRes(
      String url, Map<String, String> cookie) async {
    try {
      final request = await HttpClient().getUrl(Uri.parse(url));
      if (cookie.isNotEmpty) {
        cookie.forEach((key, value) => request.cookies.add(Cookie(key, value)));
      }
      final response = await request.close();
      return _notParseResponse(response.statusCode, response);
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }

  HttpClientResponse _notParseResponse(
      int httpStatus, HttpClientResponse response) {
    switch (httpStatus) {
      case 200:
        return response;
      default:
        throw Exception('$httpStatus');
    }
  }
}
