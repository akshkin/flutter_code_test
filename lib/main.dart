import 'package:flutter/material.dart';
import 'package:flutter_code_test/constants/theme.dart';
import 'package:flutter_code_test/pages/notification_center.dart';
import 'package:flutter_code_test/pages/stock_price_data_visualization.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme(),
      darkTheme: Themes.darkTheme(),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StockPriceDataVisualization(),
    const NotificationCenter(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stock Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        onTap: (value) => {
          setState(() {
            _selectedIndex = value;
          })
        },
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
