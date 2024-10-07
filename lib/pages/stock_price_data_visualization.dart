import 'package:flutter/material.dart';

class StockPriceDataVisualization extends StatelessWidget {
  const StockPriceDataVisualization({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Stock Price Data"),
        ),
        body: Center());
  }
}
