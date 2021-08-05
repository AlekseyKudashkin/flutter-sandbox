// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/routes.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _currentState => navigatorKey.currentState;

  late RouteSettings? lastRouteSettings;

  Future<T?> pushNamed<T>(
    String routeName, {
    Object? arguments,
  }) {
    lastRouteSettings = RouteSettings(name: routeName, arguments: arguments);
    return _currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<T?> popAndPushNamed<T>(String routeName) {
    return _currentState!.popAndPushNamed(routeName);
  }

  Future<T?> push<T>(Route<T> route) {
    return _currentState!.push(route);
  }

  Future<T?> pushReplacementNamed<T>(String routeName) {
    return _currentState!.pushReplacementNamed(routeName);
  }

  Future<T?> resetToHomePage<T>() {
    if (lastRouteSettings != null) {
      final RouteSettings innerRouteSettings = lastRouteSettings!;
      lastRouteSettings = null;
      _currentState!.pushNamedAndRemoveUntil(appPageUrl, (_) => false);
      return _currentState!.pushNamed(innerRouteSettings.name!,
          arguments: innerRouteSettings.arguments);
    }
    return _currentState!.pushNamedAndRemoveUntil(appPageUrl, (_) => false);
  }

  void pop() {
    return _currentState!.pop();
  }
}
