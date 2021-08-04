import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sandbox/theme.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController inputName = TextEditingController();
  RTCPeerConnection? _peerConnection;
  bool _inCalling = false;

  RTCDataChannelInit? _dataChannelDict;
  RTCDataChannel? _dataChannel;

  String _sdp = '';

  Future<void> submit({String? value}) async {
    var configuration = <String, dynamic>{
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'},
      ]
    };

    final offerSdpConstraints = <String, dynamic>{
      'mandatory': {
        'OfferToReceiveAudio': false,
        'OfferToReceiveVideo': false,
      },
      'optional': [],
    };

    final loopbackConstraints = <String, dynamic>{
      'mandatory': {},
      'optional': [
        {'DtlsSrtpKeyAgreement': true},
      ],
    };

    //if (_peerConnection != null) return;

    try {
      _peerConnection =
          await createPeerConnection(configuration, loopbackConstraints);

      _peerConnection!.onSignalingState = _onSignalingState;
      _peerConnection!.onIceGatheringState = _onIceGatheringState;
      _peerConnection!.onIceConnectionState = _onIceConnectionState;
      _peerConnection!.onIceCandidate = _onCandidate;
      _peerConnection!.onRenegotiationNeeded = _onRenegotiationNeeded;

      _dataChannelDict = RTCDataChannelInit();
      _dataChannelDict!.id = 1;
      _dataChannelDict!.ordered = true;
      _dataChannelDict!.maxRetransmitTime = -1;
      _dataChannelDict!.maxRetransmits = -1;
      _dataChannelDict!.protocol = 'sctp';
      _dataChannelDict!.negotiated = false;

      _dataChannel = await _peerConnection!
          .createDataChannel('dataChannel', _dataChannelDict!);
      _peerConnection!.onDataChannel = _onDataChannel;

      var description = await _peerConnection!.createOffer(offerSdpConstraints);
      print(description.sdp);
      await _peerConnection!.setLocalDescription(description);

      _sdp = description.sdp ?? '';
      print("object");
    } catch (e) {
      print(e.toString());
    }
    // if (!mounted) return;

    setState(() {
      _inCalling = true;
    });

    FocusScope.of(context).unfocus();
    Map<String, dynamic> values = {
      "name": value,
      "dataChannel": _dataChannel,
      "peerConnection": _peerConnection
    };
    print("object11");
    Navigator.pushNamed(context, '/call', arguments: values);
  }

  void _onDataChannel(RTCDataChannel dataChannel) {
    dataChannel.onMessage = (message) {
      if (message.type == MessageType.text) {
        print(message.text);
      } else {
        // do something with message.binary
      }
    };
    // or alternatively:
    dataChannel.messageStream.listen((message) {
      if (message.type == MessageType.text) {
        print(message.text);
      } else {
        // do something with message.binary
      }
    });

    dataChannel.send(RTCDataChannelMessage('Hello!'));
    dataChannel.send(RTCDataChannelMessage.fromBinary(Uint8List(5)));
  }

  void _onSignalingState(RTCSignalingState state) {
    print(state);
  }

  void _onIceGatheringState(RTCIceGatheringState state) {
    print(state);
  }

  void _onIceConnectionState(RTCIceConnectionState state) {
    print(state);
  }

  void _onCandidate(RTCIceCandidate candidate) {
    print('onCandidate: ${candidate.candidate}');
    _peerConnection?.addCandidate(candidate);
    setState(() {
      _sdp += '\n';
      _sdp += candidate.candidate ?? '';
    });
  }

  void _onRenegotiationNeeded() {
    print('RenegotiationNeeded');
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
