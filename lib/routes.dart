import 'package:flutter/material.dart';
import 'package:flutter_sandbox/screens/call/call_screen.dart';
import 'package:flutter_sandbox/screens/home/home_screen.dart';

const appPageUrl = '/';

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute(
      {required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeIn;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final offsetAnimation = animation.drive(tween);

    return new SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}

MyCustomRoute<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/call':
      String name = settings.arguments as String;
      return MyCustomRoute(
          builder: (context) => CallScreen(
                name: name,
              ),
          settings: settings);
    default:
      return MyCustomRoute(
          builder: (context) => HomeScreen(), settings: settings);
  }
}
