import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_sandbox/config/app_config.dart';
import 'package:flutter_sandbox/register_di.dart';
import 'package:flutter_sandbox/routes.dart';
import 'package:flutter_sandbox/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

void mainApp(AppConfig appConfig) {
  WidgetsFlutterBinding.ensureInitialized();
  registerDIServices(appConfig);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: appPageUrl,
      onGenerateRoute: onGenerateRoute,
      navigatorKey: GetIt.I<NavigationService>().navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
    );
  }
}
