import 'package:flutter_code_test/constants/dates.dart';
import 'package:flutter_code_test/constants/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class StockDataService {
  static Future<List<Map<String, dynamic>>> fetchStockData(
      String ticker) async {
    DateTime currentDate = DateTime.now();
    bool isDataAvailable = false;

    while (!isDataAvailable) {
      String formattedCurrentDate =
          DateFormat('yyyy-MM-dd').format(currentDate);
      try {
        final url =
            'https://api.polygon.io/v2/aggs/ticker/$ticker/range/1/minute/$formattedCurrentDate/$formattedCurrentDate?adjusted=true&sort=asc&apiKey=${Secrets.polygonAPIKey}';
        final response = await http.get(Uri.parse(url));
        Map<String, dynamic> data = jsonDecode(response.body);

        // free plan does not show data for today's date (API returns "NOT_AUTHORIZED"), check for previous dates until data is found.
        // data is available for previous day but the resultsCount is 0, check for when the resultsCount is more than 0
        if (data["status"] == "NOT_AUTHORIZED" || data["resultsCount"] == 0) {
          currentDate = currentDate.subtract(const Duration(days: 1));
        } else if (data["status"] == "OK") {
          DateConstants.latestDate = currentDate;
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
        throw Exception(e);
      }
    }
  }
}
