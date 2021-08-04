import 'package:flutter/material.dart';
import 'package:flutter_sandbox/theme.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController inputName = TextEditingController();

  void submit({String? value}) {
    FocusScope.of(context).unfocus();
    Navigator.pushNamed(context, '/call', arguments: value);
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
        onSubmitted: (value) {
          submit(value: value);
        },
        controller: inputName,
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
