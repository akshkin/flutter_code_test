import 'package:flutter/material.dart';
import 'package:flutter_code_test/constants/constants.dart';
import 'package:flutter_code_test/environment.dart';
import 'package:flutter_code_test/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  AppEnvironment.setupEnv(Environment.prod);
  runApp(const ProviderScope(child: MyApp()));
}
