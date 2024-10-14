import 'package:flutter/material.dart';
import 'package:flutter_code_test/constants/theme.dart';
import 'package:flutter_code_test/providers/notification_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationCenter extends ConsumerWidget {
  const NotificationCenter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Center"),
      ),
      body: Center(
        child: notificationState.isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  if (notificationState.isSuccess)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100,
                    ),
                  if (!notificationState.isSuccess)
                    const Icon(
                      Icons.error,
                      color: ThemeColors.errorColor,
                      size: 100,
                    ),
                  const SizedBox(height: 20),
                  // error list
                  Expanded(
                    child: ListView.builder(
                      itemCount: notificationState.errorReports.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            notificationState.errorReports[index],
                            style:
                                const TextStyle(color: ThemeColors.errorColor),
                          ),
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
