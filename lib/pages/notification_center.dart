import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_code_test/constants/theme.dart';
import 'package:flutter_code_test/service/stock_price_service.dart';
import 'package:intl/intl.dart';

class NotificationCenter extends StatefulWidget {
  const NotificationCenter({super.key});
  @override
  State<NotificationCenter> createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  bool? _isSuccess;
  final List<String> _errorReports = [];

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    Timer.periodic(const Duration(minutes: 1), (Timer timer) async {
      await fetchStockData();
    });
  }

  Future<void> fetchStockData() async {
    try {
      final data = await StockDataService.fetchStockData('AAPL');

      if (data.isNotEmpty) {
        setState(() {
          _isSuccess = true;
        });
      } else {
        setState(() {
          _isSuccess = false;
        });
      }
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleError(String message) {
    if (mounted) {
      setState(() {
        _isSuccess = false;
        _errorReports.add(
            'Error at ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())} : $message');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Center"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            if (_isSuccess == true)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
            if (_isSuccess == false)
              const Icon(
                Icons.error,
                color: ThemeColors.errorColor,
                size: 100,
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _errorReports.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_errorReports[index],
                        style: const TextStyle(color: ThemeColors.errorColor)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
