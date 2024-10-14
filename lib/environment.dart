import 'package:flutter_code_test/constants/constants.dart';

abstract class AppEnvironment {
  static late String stockTicker;
  static late String stockName;
  static late Environment _environment;

  static Environment get environment => _environment;

  static setupEnv(Environment environment) {
    _environment = environment;
    switch (environment) {
      case Environment.dev:
        stockTicker = "AAPL";
        stockName = "Apple";
        break;
      case Environment.prod:
        stockTicker = "NVDA";
        stockName = "Nvidia";
        break;
    }
  }
}
