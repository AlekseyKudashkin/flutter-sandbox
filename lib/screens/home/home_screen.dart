import 'package:flutter/material.dart';
import 'package:flutter_sandbox/services/navigation_service.dart';
import 'package:flutter_sandbox/store/home/home_store.dart';
import 'package:flutter_sandbox/theme.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeStore store = GetIt.I<HomeStore>();

  Future<void> submit() async {
    FocusScope.of(context).unfocus();
    store.nameCheck();
    GetIt.I<NavigationService>().pushNamed('/call', arguments: store.name);
  }

  Widget _getButton(double relativeWidth) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: ThemeColors.primaryColor,
        fixedSize: Size(relativeWidth, 50),
      ),
      onPressed: submit,
      child: Text("Join"),
    );
  }

  Widget _getTextField(double relativeWidth) {
    return Container(
      height: 50,
      width: relativeWidth,
      child: TextField(
        textInputAction: TextInputAction.go,
        onChanged: (String name) {
          store.name = name;
        },
        onSubmitted: (_) {
          submit();
        },
        decoration: InputDecoration(
          hintText: "Enter your name",
          focusedBorder: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
            borderSide: new BorderSide(
              color: ThemeColors.primaryColor,
              width: 2.0,
            ),
          ),
          enabledBorder: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
            borderSide: new BorderSide(
              color: ThemeColors.primaryColor,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double relativeWidth = MediaQuery.of(context).size.width - 36 * 2;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(child: _getTextField(relativeWidth)),
          SizedBox(
            height: 10,
          ),
          _getButton(relativeWidth),
        ],
      ),
    );
  }
}
