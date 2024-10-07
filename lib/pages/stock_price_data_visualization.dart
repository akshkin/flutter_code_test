import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_test/constants/theme.dart';
import 'package:flutter_code_test/environment.dart';
import 'package:flutter_code_test/service/stock_price_service.dart';
import 'package:intl/intl.dart';

class StockPriceDataVisualization extends StatelessWidget {
  const StockPriceDataVisualization({super.key});

  Future<List<Map<String, dynamic>>> fetchStockData() async {
    try {
      final String ticker = AppEnvironment.stockTicker;
      final data = await StockDataService.fetchStockData(ticker);
      return data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Widget bottomTitleWidgets(
      double value, TitleMeta meta, List<Map<String, dynamic>> stockData) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
    String text = "";

    if (value.toInt() >= 0 && value.toInt() < stockData.length) {
      // display data on X-axis in the format (HH:mm)
      final time =
          DateTime.fromMillisecondsSinceEpoch(stockData[value.toInt()]["t"]);
      final formattedTime = DateFormat('HH:mm').format(time);
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 8,
        child: Text(formattedTime, style: style),
      );
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(
      double value, TitleMeta meta, List<Map<String, dynamic>> stockData) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
    String text = '';

    if (stockData.isNotEmpty &&
        value.toInt() >= 0 &&
        value.toInt() < stockData.length) {
      // extract the closing price from the stock data
      final closingPrice = stockData[value.toInt()]["c"];
      if (closingPrice != null) {
        text = closingPrice
            .toString(); // Convert the price to a string for display
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: Text(text, style: style),
    );
  }

  double getMinY(List<double> closePrices) {
    return closePrices.reduce((a, b) => a < b ? a : b);
  }

  double getMaxY(List<double> closePrices) {
    return closePrices.reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Stock Price Data"),
      ),
      body: FutureBuilder(
        future: fetchStockData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  color: ThemeColors.errorColor,
                ),
              ),
            );
          }

          final stockData = snapshot.data!;
          final List<double> closePrices =
              stockData.map((item) => (item["c"] as num).toDouble()).toList();
          final minY = getMinY(closePrices);
          final maxY = getMaxY(closePrices);

          return Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: LineChart(
                  LineChartData(
                    minY: minY,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        color: ThemeColors.accentColor,
                        spots: stockData.asMap().entries.map((e) {
                          return FlSpot(
                            e.key.toDouble(),
                            e.value["c"].toDouble(),
                          );
                        }).toList(),
                        isCurved: true,
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) =>
                              leftTitleWidgets(value, meta, stockData),
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false, reservedSize: 10),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) =>
                              bottomTitleWidgets(value, meta, stockData),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
