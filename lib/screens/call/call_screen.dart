import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_sandbox/services/connection_service.dart';
import 'package:flutter_sandbox/services/navigation_service.dart';
import 'package:flutter_sandbox/store/call/call_store.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class CallScreen extends StatefulWidget {
  final String name;
  CallScreen({Key? key, required this.name});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallStore store = GetIt.I<CallStore>();
  final ConnectionService connectionService = GetIt.I<ConnectionService>();

  double? panelHeight;
  List<String> messageList = [];
  bool micEnabled = true;
  bool camEnabled = true;

  bool _isPanelVisible = true;

  @override
  void dispose() {
    connectionService.localRender.dispose();
    connectionService.remoteRender.dispose();
    connectionService.sdpController.dispose();
    connectionService.channel.sink.close();
    super.dispose();
  }

  @override
  void initState() {
    connectionService.webSocketConnect();
    connectionService.channel.stream.listen((data) {
      setState(() {
        print(data);
        messageList.add(data);
      });
    });
    connectionService.initRenderers();
    connectionService.createPeerConnections().then((pc) {
      connectionService.peerConnection = pc;
    });
    micEnabled = true;
    camEnabled = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPanelVisible = !_isPanelVisible;
        });
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                child: new RTCVideoView(connectionService.remoteRender),
              ),
              Observer(
                builder: (_) {
                  return AnimatedPositioned(
                    top: (store.isConnected) ? 20 : 0,
                    right: (store.isConnected) ? 14 : 0,
                    duration: Duration(milliseconds: 150),
                    child: AnimatedContainer(
                      child: new RTCVideoView(connectionService.localRender),
                      height: (store.isConnected)
                          ? 181
                          : MediaQuery.of(context).size.height,
                      width: (store.isConnected)
                          ? 119
                          : MediaQuery.of(context).size.width,
                      duration: Duration(milliseconds: 150),
                    ),
                  );
                },
              ),
              getHeadPanel(context),
              getBottomPanel(context),
            ],
          ),
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
          (store.isConnected) ? store.opponentName : store.waitingToConnect,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  double getPanelPosition(BuildContext context) {
    if (_isPanelVisible) {
      return 0;
    } else {
      return -MediaQuery.of(context).size.height / 5.5;
    }
  }

  Widget getHeadPanel(BuildContext context) {
    return AnimatedPositioned(
      top: getPanelPosition(context),
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 150),
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

  void micToggle() {
    connectionService.createOffer();
    store.isConnected = !store.isConnected;
    setState(() {
      micEnabled = !micEnabled;
    });
  }

  void camToggle() async {
    print(messageList.length);
    setState(() {
      camEnabled = !camEnabled;
    });
  }

  Future<void> disconnect() async {
    GetIt.I<NavigationService>().pop();
  }

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
      onPressed: camToggle,
      iconColor: (camEnabled) ? Colors.white : Colors.black,
    ));

    buttons.add(
      getButton(
        backgroundColor: (micEnabled)
            ? Color.fromRGBO(108, 108, 108, 1)
            : Color.fromRGBO(217, 217, 217, 1),
        asset: (micEnabled) ? 'assets/mic-on.svg' : 'assets/mic-off.svg',
        onPressed: micToggle,
        iconColor: (micEnabled) ? Colors.white : Colors.black,
      ),
    );

    buttons.add(getButton(onPressed: disconnect));
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
      bottom: getPanelPosition(context),
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 150),
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
