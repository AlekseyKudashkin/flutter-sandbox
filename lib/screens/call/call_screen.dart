import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:google_fonts/google_fonts.dart';

class CallScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;
  CallScreen({Key? key, required this.arguments});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  MediaStream? _localStream;
  final _localRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  bool _isTorchOn = false;
  MediaRecorder? _mediaRecorder;
  bool get _isRec => _mediaRecorder != null;
  double? panelHeight;

  List<MediaDeviceInfo>? _mediaDevicesList;

  bool micEnabled = true;
  bool camEnabled = true;

  bool _isPanelVisible = true;

  void _makeCall() async {
    final mediaConstraints = <String, dynamic>{
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth':
              '1280', // Provide your own width, height and frame rate here
          'minHeight': '720',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
      _localStream = stream;
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;

    setState(() {
      _inCalling = true;
    });
  }

  void _hangUp() async {
    try {
      await _localStream?.dispose();
      _localRenderer.srcObject = null;
      setState(() {
        _inCalling = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
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
    print(widget.arguments["peerConnection"]);
    setState(() {
      micEnabled = !micEnabled;
    });
  }

  void camToggle() async {
    if (_localStream == null) throw Exception('Stream is not initialized');
    final videoTrack = _localStream!
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    await Helper.switchCamera(videoTrack);

    setState(() {
      camEnabled = !camEnabled;
    });
  }

  Future<void> disconnect() async {
    RTCDataChannel? _dataChannel = widget.arguments["dataChannel"];
    RTCPeerConnection? _peerConnection = widget.arguments["peerConnection"];

    try {
      await _dataChannel?.close();
      await _peerConnection?.close();
      _peerConnection = null;
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _inCalling = false;
    });
    Navigator.pop(context);
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
