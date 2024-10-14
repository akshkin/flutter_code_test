import 'package:flutter_code_test/constants/constants.dart';
import 'package:flutter_code_test/service/stock_price_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockDataState {
  final bool isLoading;
  final bool isSuccess;
  final String error;
  final List<Map<String, dynamic>> stockPrices;

  StockDataState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error = "",
    this.stockPrices = const [],
  });

  StockDataState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    List<Map<String, dynamic>>? stockPrices,
  }) {
    return StockDataState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      stockPrices: stockPrices ?? this.stockPrices,
    );
  }
}

class StockDataNotifier extends StateNotifier<StockDataState> {
  StockDataNotifier() : super(StockDataState()) {
    fetchStockData(); // Fetch stock data initially
  }

  Future<void> fetchStockData() async {
    try {
      state = state.copyWith(isLoading: true);
      final data = await StockDataService.fetchStockData(ticker);
      if (data.isNotEmpty) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          stockPrices: data,
        );
      } else {
        _addError('Failed to fetch stock data');
      }
    } catch (e) {
      _addError(e.toString());
    }
  }

  void refreshStockData() async {
    await fetchStockData();
  }

  void _addError(String error) {
    state = state.copyWith(
      isLoading: false,
      isSuccess: false,
      error: 'Error: $error',
    );
  }
}

final stockDataProvider =
    StateNotifierProvider<StockDataNotifier, StockDataState>((ref) {
  return StockDataNotifier();
});
