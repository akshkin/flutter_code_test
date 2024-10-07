import 'package:flutter_code_test/constants/constants.dart';

abstract class AppEnvironment {
  static late String stockTicker;
  static late Environment _environment;

  static Environment get environment => _environment;

  static setupEnv(Environment environment) {
    _environment = environment;
    switch (environment) {
      case Environment.dev:
        stockTicker = "AAPL";
        break;
      case Environment.prod:
        stockTicker = "NVDA";
        break;
    }
  }
}
