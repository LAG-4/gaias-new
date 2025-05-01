import 'dart:convert';
import 'package:gaia/news_api.dart';
import 'package:http/http.dart' as http;

class NewsApiService {
  final String _baseUrl = "https://newsdata.io/api/1/latest";
  final String _apiKey = "pub_837970345139f746a8ee90bc41057b3b4de35";

Future<NewsApi?> fetchNews() async {
  final Uri uri = Uri.parse("$_baseUrl?apikey=$_apiKey");

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print("✅ Raw JSON response:");
      print(response.body); // <--- this prints the full JSON from API

      final Map<String, dynamic> data = json.decode(response.body);
      return NewsApi.fromJson(data);
    } else {
      print("❌ Failed to load news. Status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("❗Error fetching news: $e");
    return null;
  }
}

}
