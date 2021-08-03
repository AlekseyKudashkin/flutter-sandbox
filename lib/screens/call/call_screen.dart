import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CallScreen extends StatefulWidget {
  CallScreen({Key? key}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool micEnabled = true;
  bool camEnabled = true;

  @override
  void initState() {
    micEnabled = true;
    camEnabled = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.green,
            ),
            Positioned(
              top: 20,
              right: 14,
              child: Container(
                height: 181,
                width: 119,
                color: Colors.red,
              ),
            ),
            getHeadPanel(context),
            getBottomPanel(context),
          ],
        ),
      ),
    );
  }

  Widget getHeadPanelValue() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          "Parry",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  Widget getHeadPanel(BuildContext context) {
    return AnimatedPositioned(
      top: 0,
      duration: Duration(seconds: 1),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [-3.79, 99.99, 100],
            colors: [
              Color.fromRGBO(0, 0, 0, 0.86),
              Color.fromRGBO(0, 0, 0, 0.00208418),
              Color.fromRGBO(0, 0, 0, 0)
            ],
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 5.5,
        child: getHeadPanelValue(),
      ),
    );
  }

  void micTurner() {
    setState(() {
      micEnabled = !micEnabled;
    });
  }

  void camTurner() {
    setState(() {
      camEnabled = !camEnabled;
    });
  }

  void diconnect() {}

  Widget getButton(
      {Color backgroundColor = Colors.red,
      String asset = 'assets/end-call.svg',
      required Function() onPressed,
      Color iconColor = Colors.white}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: Size(55, 55),
          shape: CircleBorder(),
          primary: backgroundColor),
      onPressed: onPressed,
      child: new SvgPicture.asset(
        asset,
        color: iconColor,
      ),
    );
  }

  List<Widget> getControlButtons() {
    List<Widget> buttons = [];

    buttons.add(getButton(
      backgroundColor: (camEnabled)
          ? Color.fromRGBO(108, 108, 108, 1)
          : Color.fromRGBO(217, 217, 217, 1),
      asset: (camEnabled) ? 'assets/video-on.svg' : 'assets/video-off.svg',
      onPressed: camTurner,
      iconColor: (camEnabled) ? Colors.white : Colors.black,
    ));

    buttons.add(
      getButton(
        backgroundColor: (micEnabled)
            ? Color.fromRGBO(108, 108, 108, 1)
            : Color.fromRGBO(217, 217, 217, 1),
        asset: (micEnabled) ? 'assets/mic-on.svg' : 'assets/mic-off.svg',
        onPressed: micTurner,
        iconColor: (micEnabled) ? Colors.white : Colors.black,
      ),
    );

    buttons.add(getButton(onPressed: diconnect));
    return buttons;
  }

  Widget getBottomPanelValue() {
    return Padding(
      padding: EdgeInsets.only(top: 29, bottom: 48),
      child: Center(
        child: Container(
          height: 55,
          width: 235,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: getControlButtons(),
          ),
        ),
      ),
    );
  }

  Widget getBottomPanel(BuildContext context) {
    return AnimatedPositioned(
      bottom: 0,
      duration: Duration(seconds: 1),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [-3.79, 99.99, 100],
            colors: [
              Color.fromRGBO(0, 0, 0, 0.86),
              Color.fromRGBO(0, 0, 0, 0.00208418),
              Color.fromRGBO(0, 0, 0, 0)
            ],
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 5.5,
        child: getBottomPanelValue(),
      ),
    );
  }
}
