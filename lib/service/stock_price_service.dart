import 'package:flutter/foundation.dart';
import 'package:flutter_code_test/constants/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class StockDataService {
  static Future<List<Map<String, dynamic>>> fetchStockData(
      String ticker) async {
    // Get today's date without time (hours, minutes, seconds)
    final today = DateTime.now();
    final todaysDate = DateFormat('yyyy-MM-dd').format(today);

    final url =
        'https://api.polygon.io/v2/aggs/ticker/$ticker/range/1/minute/2023-02-09/2023-02-09?adjusted=true&sort=asc&apiKey=${Secrets.polygonAPIKey}';

    try {
      final response = await http.get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data["status"] == "OK") {
        // Check if 'results' exists and is a list
        if (data.containsKey("results") && data["results"] is List) {
          // json first parses as dynamic
          final List<dynamic> results = data["results"];

          // explicitly cast
          List<Map<String, dynamic>> castResults =
              results.map((item) => item as Map<String, dynamic>).toList();

          // Return the properly cast list of maps
          return castResults;
        } else {
          throw Exception('No results found in the response.');
        }
      } else {
        throw Exception('Failed to load stock data');
      }
    } catch (e) {
      throw Exception('Failed to load stock data: $e');
    }
  }
}
