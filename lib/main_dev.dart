import 'package:flutter/material.dart';
import 'package:flutter_code_test/constants/constants.dart';
import 'package:flutter_code_test/environment.dart';
import 'package:flutter_code_test/app.dart';

void main() async {
  AppEnvironment.setupEnv(Environment.dev);
  runApp(const MyApp());
}
