import 'dart:async';
import 'package:flutter_code_test/constants/constants.dart';
import 'package:flutter_code_test/service/stock_price_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationState {
  final bool isLoading;
  final bool isSuccess;
  final List<String> errorReports;

  NotificationState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<String>? errorReports,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorReports: errorReports ?? this.errorReports,
    );
  }

  NotificationState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorReports = const [],
  });
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(NotificationState()) {
    _startPolling();
  }

  Future<void> fetchNotificationData() async {
    try {
      state = state.copyWith(isLoading: true);
      final data = await StockDataService.fetchStockData(ticker);
      if (data.isNotEmpty) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        _addError('Failed to fetch notification data');
      }
    } catch (e) {
      _addError(e.toString());
    }
  }

  void _startPolling() async {
    await fetchNotificationData();

    Timer.periodic(const Duration(minutes: 1), (Timer timer) async {
      await fetchNotificationData();
    });
  }

  void _addError(String error) {
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    state = state.copyWith(
      isLoading: false,
      isSuccess: false,
      errorReports: ['Error at $timestamp: $error', ...state.errorReports],
    );
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});
