import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_test/constants/constants.dart';
import 'package:flutter_code_test/constants/dates.dart';
import 'package:flutter_code_test/constants/theme.dart';
import 'package:flutter_code_test/providers/stock_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StockPriceDataVisualization extends ConsumerWidget {
  const StockPriceDataVisualization({super.key});

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
    String text =
        value.toStringAsFixed(3); // Convert the price to a string for display

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: Text(text, style: style),
    );
  }

  double getMinY(List<double> closePrices) {
    if (closePrices.isNotEmpty) {
      return closePrices.reduce((a, b) => a < b ? a : b);
    }
    return 0;
  }

  double getMaxY(List<double> closePrices) {
    if (closePrices.isNotEmpty) {
      return closePrices.reduce((a, b) => a > b ? a : b);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockDataState = ref.watch(stockDataProvider);
    final List<double> closePrices = stockDataState.stockPrices
        .map((item) => (item["c"] as num).toDouble())
        .toList();
    final minY = getMinY(closePrices);
    final maxY = getMaxY(closePrices);

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Stock Price Data"),
        actions: [
          IconButton(
            onPressed: () {
              ref.watch(stockDataProvider.notifier).refreshStockData();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: stockDataState.isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Fetching data for latest available day")
                ],
              )
            : stockDataState.isSuccess
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 0.8,
                          child: LineChart(
                            LineChartData(
                              minY: minY,
                              maxY: maxY,
                              lineBarsData: [
                                LineChartBarData(
                                  color: ThemeColors.accentColor,
                                  spots: stockDataState.stockPrices
                                      .asMap()
                                      .entries
                                      .map((e) {
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
                                  axisNameWidget: const Text(
                                    "Closing price (USD)",
                                  ),
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 65,
                                    getTitlesWidget: (value, meta) =>
                                        leftTitleWidgets(value, meta,
                                            stockDataState.stockPrices),
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: false, reservedSize: 10),
                                ),
                                bottomTitles: AxisTitles(
                                  axisNameWidget: const Text(
                                    "Time (HH:mm)",
                                  ),
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) =>
                                        bottomTitleWidgets(value, meta,
                                            stockDataState.stockPrices),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                            "Stock data for $stockName as of ${DateConstants.formattedLatestDate}")
                      ],
                    ),
                  )
                : !stockDataState.isSuccess
                    ? Text(
                        stockDataState.error,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox(),
      ),
    );
  }
}
